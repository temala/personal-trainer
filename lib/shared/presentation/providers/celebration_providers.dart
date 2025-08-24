import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/shared/data/services/celebration_service.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/presentation/providers/exercise_providers.dart';

/// Provider for celebration service
final celebrationServiceProvider = Provider<CelebrationService>((ref) {
  return CelebrationService();
});

/// Provider for generating celebration data
final celebrationDataProvider =
    FutureProvider.family<Map<String, dynamic>, CelebrationParams>((
      ref,
      params,
    ) async {
      final celebrationService = ref.read(celebrationServiceProvider);

      return celebrationService.generateCelebrationData(
        exercise: params.exercise,
        session: params.session,
        userStats: params.userStats,
      );
    });

/// Provider for celebration effects
final celebrationEffectsProvider =
    Provider.family<Map<String, dynamic>, CelebrationType>((ref, type) {
      final celebrationService = ref.read(celebrationServiceProvider);
      return celebrationService.generateCelebrationEffects(type);
    });

/// Provider for celebration animation data
final celebrationAnimationProvider =
    FutureProvider.family<ExerciseAnimationData?, CelebrationType>((
      ref,
      type,
    ) async {
      final animationService = ref.read<ExerciseAnimationService>(
        exerciseAnimationServiceProvider,
      );
      return animationService.getCelebrationAnimation(type: type);
    });

/// Parameters for celebration data generation
@immutable
class CelebrationParams {
  const CelebrationParams({
    required this.exercise,
    required this.session,
    this.userStats,
  });

  final Exercise exercise;
  final WorkoutSession session;
  final Map<String, dynamic>? userStats;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CelebrationParams &&
        other.exercise.id == exercise.id &&
        other.session.id == session.id &&
        other.userStats == userStats;
  }

  @override
  int get hashCode {
    return exercise.id.hashCode ^ session.id.hashCode ^ userStats.hashCode;
  }
}
