import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:fitness_training_app/core/constants/firebase_constants.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/local_database.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';

/// Service for managing exercise animations and demonstrations
class ExerciseAnimationService {
  ExerciseAnimationService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  /// Initialize the animation service
  Future<void> initialize() async {
    try {
      // Animation cache is already initialized by LocalDatabase
      AppLogger.info('Exercise animation service initialized');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize animation service', e, stackTrace);
    }
  }

  /// Get animation cache box
  Box<CachedAnimation> get _animationCache => LocalDatabase.animationCacheBox;

  /// Get animation data for an exercise
  Future<ExerciseAnimationData?> getExerciseAnimation(String exerciseId) async {
    try {
      // Check cache first
      final cachedAnimation = _animationCache.get(exerciseId);
      if (cachedAnimation != null && !cachedAnimation.isStale) {
        AppLogger.info('Returning cached animation for exercise $exerciseId');
        return cachedAnimation.animationData;
      }

      // Try to load from assets first (for bundled animations)
      final assetAnimation = await _loadAnimationFromAssets(exerciseId);
      if (assetAnimation != null) {
        await _cacheAnimation(exerciseId, assetAnimation);
        return assetAnimation;
      }

      // Load from Firebase Storage
      final storageAnimation = await _loadAnimationFromStorage(exerciseId);
      if (storageAnimation != null) {
        await _cacheAnimation(exerciseId, storageAnimation);
        return storageAnimation;
      }

      // Return default animation if specific one not found
      final defaultAnimation = await _getDefaultAnimation();
      if (defaultAnimation != null) {
        AppLogger.warning('Using default animation for exercise $exerciseId');
        return defaultAnimation;
      }

      AppLogger.warning('No animation found for exercise $exerciseId');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting animation for exercise $exerciseId',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Get user avatar animation for an exercise
  Future<ExerciseAnimationData?> getUserAvatarAnimation({
    required String exerciseId,
    required String userId,
    required AvatarData avatarData,
  }) async {
    try {
      // Check if user has custom avatar animations
      final avatarAnimationId = '${userId}_${exerciseId}';
      final cachedAvatarAnimation = _animationCache.get(avatarAnimationId);

      if (cachedAvatarAnimation != null && !cachedAvatarAnimation.isStale) {
        AppLogger.info(
          'Returning cached avatar animation for $avatarAnimationId',
        );
        return cachedAvatarAnimation.animationData;
      }

      // Try to load avatar-specific animation from storage
      final avatarAnimation = await _loadAvatarAnimationFromStorage(
        exerciseId: exerciseId,
        userId: userId,
        avatarData: avatarData,
      );

      if (avatarAnimation != null) {
        await _cacheAnimation(avatarAnimationId, avatarAnimation);
        return avatarAnimation;
      }

      // Fallback to default exercise animation
      AppLogger.info(
        'No avatar animation found, using default for exercise $exerciseId',
      );
      return getExerciseAnimation(exerciseId);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting avatar animation', e, stackTrace);
      return getExerciseAnimation(exerciseId);
    }
  }

  /// Get celebration animation
  Future<ExerciseAnimationData?> getCelebrationAnimation({
    CelebrationType type = CelebrationType.exerciseComplete,
  }) async {
    try {
      final animationId = 'celebration_${type.name}';

      // Check cache first
      final cachedAnimation = _animationCache.get(animationId);
      if (cachedAnimation != null && !cachedAnimation.isStale) {
        return cachedAnimation.animationData;
      }

      // Load celebration animation
      final celebrationAnimation = await _loadCelebrationAnimation(type);
      if (celebrationAnimation != null) {
        await _cacheAnimation(animationId, celebrationAnimation);
        return celebrationAnimation;
      }

      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting celebration animation', e, stackTrace);
      return null;
    }
  }

  /// Preload animations for a list of exercises
  Future<void> preloadExerciseAnimations(List<Exercise> exercises) async {
    try {
      AppLogger.info('Preloading animations for ${exercises.length} exercises');

      final preloadTasks = exercises.map((exercise) async {
        try {
          await getExerciseAnimation(exercise.id);
        } catch (e) {
          AppLogger.warning(
            'Failed to preload animation for ${exercise.id}: $e',
          );
        }
      });

      await Future.wait(preloadTasks);
      AppLogger.info('Completed preloading exercise animations');
    } catch (e, stackTrace) {
      AppLogger.error('Error preloading exercise animations', e, stackTrace);
    }
  }

  /// Clear animation cache
  Future<void> clearCache() async {
    try {
      await _animationCache.clear();
      AppLogger.info('Animation cache cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing animation cache', e, stackTrace);
    }
  }

  /// Get cache status
  Future<Map<String, dynamic>> getCacheStatus() async {
    final cache = _animationCache;
    final totalSize = cache.values.fold<int>(
      0,
      (sum, cached) => sum + cached.sizeBytes,
    );
    final staleCount = cache.values.where((cached) => cached.isStale).length;

    return {
      'cacheSize': cache.length,
      'totalSizeBytes': totalSize,
      'staleAnimations': staleCount,
      'isInitialized': true,
    };
  }

  /// Clean up stale cache entries
  Future<void> cleanupCache() async {
    try {
      final cache = _animationCache;
      final staleKeys = <String>[];
      for (final entry in cache.toMap().entries) {
        if (entry.value.isStale) {
          staleKeys.add(entry.key.toString());
        }
      }

      for (final key in staleKeys) {
        await cache.delete(key);
      }

      AppLogger.info(
        'Cleaned up ${staleKeys.length} stale animation cache entries',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error cleaning up animation cache', e, stackTrace);
    }
  }

  // Private helper methods

  Future<ExerciseAnimationData?> _loadAnimationFromAssets(
    String exerciseId,
  ) async {
    try {
      // Try different asset paths
      final assetPaths = [
        'assets/animations/exercises/$exerciseId.json',
        'assets/animations/exercises/${exerciseId.toLowerCase()}.json',
        'assets/lottie/$exerciseId.json',
      ];

      for (final assetPath in assetPaths) {
        try {
          final animationData = await rootBundle.loadString(assetPath);
          AppLogger.info('Loaded animation from assets: $assetPath');

          return ExerciseAnimationData(
            id: exerciseId,
            type: AnimationType.lottie,
            data: animationData,
            source: AnimationSource.assets,
            duration: _extractAnimationDuration(animationData),
            isLooping: true,
            metadata: {'assetPath': assetPath},
          );
        } catch (e) {
          // Continue to next asset path
        }
      }

      return null;
    } catch (e) {
      AppLogger.warning(
        'Could not load animation from assets for $exerciseId: $e',
      );
      return null;
    }
  }

  Future<ExerciseAnimationData?> _loadAnimationFromStorage(
    String exerciseId,
  ) async {
    try {
      final ref = _storage
          .ref()
          .child(FirebaseConstants.exerciseAnimationsPath)
          .child('$exerciseId.json');

      final data = await ref.getData();
      if (data != null) {
        final animationData = String.fromCharCodes(data);
        AppLogger.info('Loaded animation from Firebase Storage: $exerciseId');

        return ExerciseAnimationData(
          id: exerciseId,
          type: AnimationType.lottie,
          data: animationData,
          source: AnimationSource.storage,
          duration: _extractAnimationDuration(animationData),
          isLooping: true,
          metadata: {'storageRef': ref.fullPath},
        );
      }

      return null;
    } catch (e) {
      AppLogger.warning(
        'Could not load animation from storage for $exerciseId: $e',
      );
      return null;
    }
  }

  Future<ExerciseAnimationData?> _loadAvatarAnimationFromStorage({
    required String exerciseId,
    required String userId,
    required AvatarData avatarData,
  }) async {
    try {
      final ref = _storage
          .ref()
          .child(FirebaseConstants.userAvatarsPath)
          .child(userId)
          .child('animations')
          .child('$exerciseId.json');

      final data = await ref.getData();
      if (data != null) {
        final animationData = String.fromCharCodes(data);
        AppLogger.info(
          'Loaded avatar animation from storage: ${userId}_$exerciseId',
        );

        return ExerciseAnimationData(
          id: '${userId}_$exerciseId',
          type: AnimationType.lottie,
          data: animationData,
          source: AnimationSource.storage,
          duration: _extractAnimationDuration(animationData),
          isLooping: true,
          metadata: {
            'storageRef': ref.fullPath,
            'userId': userId,
            'avatarId': avatarData.id,
          },
        );
      }

      return null;
    } catch (e) {
      AppLogger.warning('Could not load avatar animation from storage: $e');
      return null;
    }
  }

  Future<ExerciseAnimationData?> _loadCelebrationAnimation(
    CelebrationType type,
  ) async {
    try {
      final assetPath = 'assets/animations/celebrations/${type.name}.json';
      final animationData = await rootBundle.loadString(assetPath);

      return ExerciseAnimationData(
        id: 'celebration_${type.name}',
        type: AnimationType.lottie,
        data: animationData,
        source: AnimationSource.assets,
        duration: _extractAnimationDuration(animationData),
        isLooping: false,
        metadata: {'celebrationType': type.name},
      );
    } catch (e) {
      AppLogger.warning(
        'Could not load celebration animation for ${type.name}: $e',
      );
      return null;
    }
  }

  Future<ExerciseAnimationData?> _getDefaultAnimation() async {
    try {
      const assetPath = 'assets/animations/default_exercise.json';
      final animationData = await rootBundle.loadString(assetPath);

      return ExerciseAnimationData(
        id: 'default_exercise',
        type: AnimationType.lottie,
        data: animationData,
        source: AnimationSource.assets,
        duration: 3000, // 3 seconds default
        isLooping: true,
        metadata: {'isDefault': true},
      );
    } catch (e) {
      AppLogger.warning('Could not load default animation: $e');
      return null;
    }
  }

  Future<void> _cacheAnimation(
    String id,
    ExerciseAnimationData animationData,
  ) async {
    try {
      final cache = _animationCache;
      final cachedAnimation = CachedAnimation(
        id: id,
        animationData: animationData,
        cachedAt: DateTime.now(),
        sizeBytes: animationData.data.length,
        accessCount: 0,
        lastAccessed: DateTime.now(),
      );

      await cache.put(id, cachedAnimation);
    } catch (e, stackTrace) {
      AppLogger.error('Error caching animation $id', e, stackTrace);
    }
  }

  int _extractAnimationDuration(String animationData) {
    try {
      // This is a simplified duration extraction
      // In a real implementation, you would parse the Lottie JSON
      // to get the actual frame rate and frame count
      return 3000; // Default 3 seconds
    } catch (e) {
      return 3000; // Default fallback
    }
  }
}

/// Exercise animation data
class ExerciseAnimationData {
  const ExerciseAnimationData({
    required this.id,
    required this.type,
    required this.data,
    required this.source,
    required this.duration,
    required this.isLooping,
    required this.metadata,
  });

  final String id;
  final AnimationType type;
  final String data;
  final AnimationSource source;
  final int duration; // in milliseconds
  final bool isLooping;
  final Map<String, dynamic> metadata;
}

/// Avatar data for custom animations
class AvatarData {
  const AvatarData({
    required this.id,
    required this.userId,
    required this.characteristics,
    required this.createdAt,
    required this.availableAnimations,
  });

  final String id;
  final String userId;
  final Map<String, dynamic> characteristics;
  final DateTime createdAt;
  final List<String> availableAnimations;
}

/// Cached animation with metadata
@HiveType(typeId: 25)
class CachedAnimation extends HiveObject {
  CachedAnimation({
    required this.id,
    required this.animationData,
    required this.cachedAt,
    required this.sizeBytes,
    required this.accessCount,
    required this.lastAccessed,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  ExerciseAnimationData animationData;

  @HiveField(2)
  DateTime cachedAt;

  @HiveField(3)
  int sizeBytes;

  @HiveField(4)
  int accessCount;

  @HiveField(5)
  DateTime lastAccessed;

  /// Check if cache is stale
  bool get isStale {
    return DateTime.now().difference(cachedAt) > const Duration(days: 30);
  }

  /// Mark as accessed
  void markAccessed() {
    lastAccessed = DateTime.now();
    accessCount++;
    if (isInBox) save();
  }
}

/// Animation types
enum AnimationType { lottie, rive, gif, video }

/// Animation sources
enum AnimationSource { assets, storage, cache, generated }

/// Celebration types
enum CelebrationType {
  exerciseComplete,
  workoutComplete,
  personalRecord,
  streakAchieved,
  goalReached,
}
