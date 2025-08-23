import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/workout_session_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/domain/repositories/workout_repository.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';

/// Service for persisting and recovering workout session state
class WorkoutSessionPersistenceService {
  static const String _sessionStateKey = 'workout_session_state';

  final SharedPreferences _prefs;
  final Box<Map<String, dynamic>> _sessionBox;

  WorkoutSessionPersistenceService({
    required SharedPreferences prefs,
    required Box<Map<String, dynamic>> sessionBox,
  }) : _prefs = prefs,
       _sessionBox = sessionBox;

  /// Save current session state to persistent storage
  Future<void> saveSessionState(WorkoutSessionState state) async {
    try {
      final stateData = _serializeSessionState(state);

      // Save to SharedPreferences for quick access
      await _prefs.setString(_sessionStateKey, jsonEncode(stateData));

      // Save to Hive for more complex data
      await _sessionBox.put('current_session_state', stateData);

      AppLogger.info('Session state saved successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Error saving session state', e, stackTrace);
      rethrow;
    }
  }

  /// Load saved session state from persistent storage
  Future<WorkoutSessionState?> loadSessionState() async {
    try {
      // Try SharedPreferences first
      final stateJson = _prefs.getString(_sessionStateKey);
      Map<String, dynamic>? stateData;

      if (stateJson != null) {
        stateData = jsonDecode(stateJson) as Map<String, dynamic>;
      } else {
        // Fallback to Hive
        stateData = _sessionBox.get('current_session_state');
      }

      if (stateData != null) {
        final state = _deserializeSessionState(stateData);
        AppLogger.info('Session state loaded successfully');
        return state;
      }

      AppLogger.info('No saved session state found');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error loading session state', e, stackTrace);
      return null;
    }
  }

  /// Clear saved session state
  Future<void> clearSessionState() async {
    try {
      await _prefs.remove(_sessionStateKey);
      await _sessionBox.delete('current_session_state');
      AppLogger.info('Session state cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing session state', e, stackTrace);
    }
  }

  /// Save session recovery data for later evaluation
  Future<void> saveSessionRecoveryData({
    required String sessionId,
    required String userId,
    required DateTime lastActiveTime,
    required int currentExerciseIndex,
    required bool wasRecovering,
    required int recoveryTimeRemaining,
    required Map<String, dynamic> sessionMetadata,
  }) async {
    try {
      final recoveryData = {
        'sessionId': sessionId,
        'userId': userId,
        'lastActiveTime': lastActiveTime.toIso8601String(),
        'currentExerciseIndex': currentExerciseIndex,
        'wasRecovering': wasRecovering,
        'recoveryTimeRemaining': recoveryTimeRemaining,
        'sessionMetadata': sessionMetadata,
        'savedAt': DateTime.now().toIso8601String(),
      };

      await _sessionBox.put('recovery_data_$sessionId', recoveryData);
      AppLogger.info('Session recovery data saved for session: $sessionId');
    } catch (e, stackTrace) {
      AppLogger.error('Error saving session recovery data', e, stackTrace);
    }
  }

  /// Load session recovery data
  Future<SessionRecoveryData?> loadSessionRecoveryData(String sessionId) async {
    try {
      final recoveryData = _sessionBox.get('recovery_data_$sessionId');
      if (recoveryData != null) {
        return SessionRecoveryData.fromMap(recoveryData);
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error loading session recovery data', e, stackTrace);
      return null;
    }
  }

  /// Get all pending recovery sessions
  Future<List<SessionRecoveryData>> getPendingRecoverySessions() async {
    try {
      final recoverySessions = <SessionRecoveryData>[];

      for (final key in _sessionBox.keys) {
        if (key.toString().startsWith('recovery_data_')) {
          final data = _sessionBox.get(key);
          if (data != null) {
            try {
              final recoveryData = SessionRecoveryData.fromMap(data);
              recoverySessions.add(recoveryData);
            } catch (e) {
              AppLogger.warning('Invalid recovery data for key: $key');
            }
          }
        }
      }

      // Sort by last active time (most recent first)
      recoverySessions.sort(
        (a, b) => b.lastActiveTime.compareTo(a.lastActiveTime),
      );

      return recoverySessions;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting pending recovery sessions', e, stackTrace);
      return [];
    }
  }

  /// Clear recovery data for a session
  Future<void> clearSessionRecoveryData(String sessionId) async {
    try {
      await _sessionBox.delete('recovery_data_$sessionId');
      AppLogger.info('Recovery data cleared for session: $sessionId');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing session recovery data', e, stackTrace);
    }
  }

  /// Check if there are any sessions that need recovery
  Future<bool> hasSessionsNeedingRecovery() async {
    try {
      final recoverySessions = await getPendingRecoverySessions();
      return recoverySessions.isNotEmpty;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking for sessions needing recovery',
        e,
        stackTrace,
      );
      return false;
    }
  }

  /// Clean up old recovery data (older than 7 days)
  Future<void> cleanupOldRecoveryData() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 7));
      final keysToDelete = <String>[];

      for (final key in _sessionBox.keys) {
        if (key.toString().startsWith('recovery_data_')) {
          final data = _sessionBox.get(key);
          if (data != null) {
            try {
              final recoveryData = SessionRecoveryData.fromMap(data);
              if (recoveryData.lastActiveTime.isBefore(cutoffDate)) {
                keysToDelete.add(key.toString());
              }
            } catch (e) {
              // Invalid data, mark for deletion
              keysToDelete.add(key.toString());
            }
          }
        }
      }

      for (final key in keysToDelete) {
        await _sessionBox.delete(key);
      }

      if (keysToDelete.isNotEmpty) {
        AppLogger.info(
          'Cleaned up ${keysToDelete.length} old recovery data entries',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error cleaning up old recovery data', e, stackTrace);
    }
  }

  /// Save app lifecycle state for session recovery
  Future<void> saveAppLifecycleState({
    required bool wasInForeground,
    required DateTime timestamp,
    String? activeSessionId,
  }) async {
    try {
      final lifecycleData = {
        'wasInForeground': wasInForeground,
        'timestamp': timestamp.toIso8601String(),
        'activeSessionId': activeSessionId,
      };

      await _sessionBox.put('app_lifecycle_state', lifecycleData);
    } catch (e, stackTrace) {
      AppLogger.error('Error saving app lifecycle state', e, stackTrace);
    }
  }

  /// Load app lifecycle state
  Future<AppLifecycleData?> loadAppLifecycleState() async {
    try {
      final lifecycleData = _sessionBox.get('app_lifecycle_state');
      if (lifecycleData != null) {
        return AppLifecycleData.fromMap(lifecycleData);
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error loading app lifecycle state', e, stackTrace);
      return null;
    }
  }

  // Private methods

  Map<String, dynamic> _serializeSessionState(WorkoutSessionState state) {
    switch (state) {
      case IdleWorkoutSessionState():
        return {'type': 'idle'};

      case ActiveWorkoutSessionState():
        return {
          'type': 'active',
          'session': state.session.toJson(),
          'currentExerciseIndex': state.currentExerciseIndex,
          'isRecovering': state.isRecovering,
          'recoveryTimeRemaining': state.recoveryTimeRemaining,
        };

      case PausedWorkoutSessionState():
        return {
          'type': 'paused',
          'session': state.session.toJson(),
          'currentExerciseIndex': state.currentExerciseIndex,
          'wasRecovering': state.wasRecovering,
          'recoveryTimeRemaining': state.recoveryTimeRemaining,
        };

      case CompletedWorkoutSessionState():
        return {'type': 'completed', 'session': state.session.toJson()};

      case AbandonedWorkoutSessionState():
        return {'type': 'abandoned', 'session': state.session.toJson()};

      case ErrorWorkoutSessionState():
        return {
          'type': 'error',
          'message': state.message,
          'session': state.session?.toJson(),
        };
    }
  }

  WorkoutSessionState _deserializeSessionState(Map<String, dynamic> data) {
    final type = data['type'] as String;

    switch (type) {
      case 'idle':
        return const WorkoutSessionState.idle();

      case 'active':
        return WorkoutSessionState.active(
          session: WorkoutSession.fromJson(
            data['session'] as Map<String, dynamic>,
          ),
          currentExerciseIndex: data['currentExerciseIndex'] as int,
          isRecovering: data['isRecovering'] as bool,
          recoveryTimeRemaining: data['recoveryTimeRemaining'] as int,
        );

      case 'paused':
        return WorkoutSessionState.paused(
          session: WorkoutSession.fromJson(
            data['session'] as Map<String, dynamic>,
          ),
          currentExerciseIndex: data['currentExerciseIndex'] as int,
          wasRecovering: data['wasRecovering'] as bool,
          recoveryTimeRemaining: data['recoveryTimeRemaining'] as int,
        );

      case 'completed':
        return WorkoutSessionState.completed(
          session: WorkoutSession.fromJson(
            data['session'] as Map<String, dynamic>,
          ),
        );

      case 'abandoned':
        return WorkoutSessionState.abandoned(
          session: WorkoutSession.fromJson(
            data['session'] as Map<String, dynamic>,
          ),
        );

      case 'error':
        return WorkoutSessionState.error(
          message: data['message'] as String,
          session:
              data['session'] != null
                  ? WorkoutSession.fromJson(
                    data['session'] as Map<String, dynamic>,
                  )
                  : null,
        );

      default:
        throw ArgumentError('Unknown session state type: $type');
    }
  }
}

/// Data class for session recovery information
class SessionRecoveryData {
  const SessionRecoveryData({
    required this.sessionId,
    required this.userId,
    required this.lastActiveTime,
    required this.currentExerciseIndex,
    required this.wasRecovering,
    required this.recoveryTimeRemaining,
    required this.sessionMetadata,
    required this.savedAt,
  });

  final String sessionId;
  final String userId;
  final DateTime lastActiveTime;
  final int currentExerciseIndex;
  final bool wasRecovering;
  final int recoveryTimeRemaining;
  final Map<String, dynamic> sessionMetadata;
  final DateTime savedAt;

  factory SessionRecoveryData.fromMap(Map<String, dynamic> map) {
    return SessionRecoveryData(
      sessionId: map['sessionId'] as String,
      userId: map['userId'] as String,
      lastActiveTime: DateTime.parse(map['lastActiveTime'] as String),
      currentExerciseIndex: map['currentExerciseIndex'] as int,
      wasRecovering: map['wasRecovering'] as bool,
      recoveryTimeRemaining: map['recoveryTimeRemaining'] as int,
      sessionMetadata: Map<String, dynamic>.from(map['sessionMetadata'] as Map),
      savedAt: DateTime.parse(map['savedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'lastActiveTime': lastActiveTime.toIso8601String(),
      'currentExerciseIndex': currentExerciseIndex,
      'wasRecovering': wasRecovering,
      'recoveryTimeRemaining': recoveryTimeRemaining,
      'sessionMetadata': sessionMetadata,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  /// Check if this session was recently active (within last 30 minutes)
  bool get isRecentlyActive {
    final thirtyMinutesAgo = DateTime.now().subtract(
      const Duration(minutes: 30),
    );
    return lastActiveTime.isAfter(thirtyMinutesAgo);
  }

  /// Get formatted time since last active
  String get timeSinceLastActive {
    final now = DateTime.now();
    final difference = now.difference(lastActiveTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}

/// Data class for app lifecycle state
class AppLifecycleData {
  const AppLifecycleData({
    required this.wasInForeground,
    required this.timestamp,
    this.activeSessionId,
  });

  final bool wasInForeground;
  final DateTime timestamp;
  final String? activeSessionId;

  factory AppLifecycleData.fromMap(Map<String, dynamic> map) {
    return AppLifecycleData(
      wasInForeground: map['wasInForeground'] as bool,
      timestamp: DateTime.parse(map['timestamp'] as String),
      activeSessionId: map['activeSessionId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wasInForeground': wasInForeground,
      'timestamp': timestamp.toIso8601String(),
      'activeSessionId': activeSessionId,
    };
  }
}

/// Enhanced workout session manager with persistence
class PersistentWorkoutSessionManager extends WorkoutSessionManager {
  final WorkoutSessionPersistenceService _persistenceService;
  final WorkoutRepository _workoutRepository;
  Timer? _persistenceTimer;

  PersistentWorkoutSessionManager({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
    required WorkoutSessionPersistenceService persistenceService,
  }) : _persistenceService = persistenceService,
       _workoutRepository = workoutRepository,
       super(
         workoutRepository: workoutRepository,
         exerciseRepository: exerciseRepository,
       ) {
    _startPeriodicPersistence();
    _loadSavedState();
  }

  /// Start periodic saving of session state
  void _startPeriodicPersistence() {
    _persistenceTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _saveCurrentState();
    });
  }

  /// Load saved session state on initialization
  Future<void> _loadSavedState() async {
    try {
      final savedState = await _persistenceService.loadSessionState();
      if (savedState != null && savedState is! IdleWorkoutSessionState) {
        AppLogger.info('Restoring saved session state');
        updateState(savedState);

        // If it was an active session, check if we need to handle recovery
        if (savedState is ActiveWorkoutSessionState ||
            savedState is PausedWorkoutSessionState) {
          await _handleSessionRecovery(savedState);
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error loading saved session state', e, stackTrace);
    }
  }

  /// Handle session recovery logic
  Future<void> _handleSessionRecovery(WorkoutSessionState savedState) async {
    try {
      final lifecycleState = await _persistenceService.loadAppLifecycleState();

      if (lifecycleState != null) {
        final timeSinceLastActive = DateTime.now().difference(
          lifecycleState.timestamp,
        );

        // If app was backgrounded for more than 5 minutes, pause the session
        if (timeSinceLastActive.inMinutes > 5 &&
            savedState is ActiveWorkoutSessionState) {
          final pausedSession = savedState.session.copyWith(
            status: SessionStatus.paused,
            pausedAt: lifecycleState.timestamp,
          );

          await _workoutRepository.updateWorkoutSession(pausedSession);

          updateState(
            WorkoutSessionState.paused(
              session: pausedSession,
              currentExerciseIndex: savedState.currentExerciseIndex,
              wasRecovering: savedState.isRecovering,
              recoveryTimeRemaining: savedState.recoveryTimeRemaining,
            ),
          );

          AppLogger.info(
            'Session automatically paused due to app backgrounding',
          );
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error handling session recovery', e, stackTrace);
    }
  }

  /// Save current session state
  Future<void> _saveCurrentState() async {
    try {
      await _persistenceService.saveSessionState(currentState);

      // Save recovery data for active sessions
      if (currentState is ActiveWorkoutSessionState) {
        final state = currentState as ActiveWorkoutSessionState;
        await _persistenceService.saveSessionRecoveryData(
          sessionId: state.session.id,
          userId: state.session.userId,
          lastActiveTime: DateTime.now(),
          currentExerciseIndex: state.currentExerciseIndex,
          wasRecovering: state.isRecovering,
          recoveryTimeRemaining: state.recoveryTimeRemaining,
          sessionMetadata: state.session.metadata,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error saving current session state', e, stackTrace);
    }
  }

  /// Public method to save current state (for lifecycle handler)
  Future<void> saveCurrentState() async {
    await _saveCurrentState();
  }

  /// Handle app lifecycle changes
  Future<void> handleAppLifecycleChange(
    AppLifecycleState lifecycleState,
  ) async {
    try {
      await _persistenceService.saveAppLifecycleState(
        wasInForeground: lifecycleState == AppLifecycleState.resumed,
        timestamp: DateTime.now(),
        activeSessionId: currentState.session?.id,
      );

      // Save current state when app goes to background
      if (lifecycleState == AppLifecycleState.paused ||
          lifecycleState == AppLifecycleState.inactive) {
        await _saveCurrentState();
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error handling app lifecycle change', e, stackTrace);
    }
  }

  /// Get sessions that need recovery
  Future<List<SessionRecoveryData>> getSessionsNeedingRecovery() async {
    return _persistenceService.getPendingRecoverySessions();
  }

  /// Clear recovery data for a session
  Future<void> clearRecoveryData(String sessionId) async {
    await _persistenceService.clearSessionRecoveryData(sessionId);
  }

  @override
  Future<void> endSession() async {
    await super.endSession();

    // Clear persistence data when session ends
    await _persistenceService.clearSessionState();
    if (currentState.session != null) {
      await _persistenceService.clearSessionRecoveryData(
        currentState.session!.id,
      );
    }
  }

  @override
  void dispose() {
    _persistenceTimer?.cancel();
    _saveCurrentState(); // Save final state
    super.dispose();
  }
}
