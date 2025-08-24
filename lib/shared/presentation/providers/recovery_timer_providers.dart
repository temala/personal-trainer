import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/shared/data/services/recovery_timer_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';

/// Provider for recovery timer service
final recoveryTimerServiceProvider = Provider<RecoveryTimerService>((ref) {
  return RecoveryTimerService();
});

/// Provider for calculating recovery time
final recoveryTimeProvider = Provider.family<Duration, RecoveryTimeParams>((
  ref,
  params,
) {
  final service = ref.read(recoveryTimerServiceProvider);

  return service.calculateRecoveryTime(
    exercise: params.exercise,
    userProfile: params.userProfile,
    sessionData: params.sessionData,
  );
});

/// Provider for recovery activities
final recoveryActivitiesProvider = Provider.family<List<String>, Exercise>((
  ref,
  exercise,
) {
  final service = ref.read(recoveryTimerServiceProvider);
  return service.getRecoveryActivities(exercise);
});

/// Provider for recovery tips
final recoveryTipsProvider = Provider.family<List<String>, DifficultyLevel>((
  ref,
  difficulty,
) {
  final service = ref.read(recoveryTimerServiceProvider);
  return service.getRecoveryTips(difficulty);
});

/// Parameters for recovery time calculation
@immutable
class RecoveryTimeParams {
  const RecoveryTimeParams({
    required this.exercise,
    this.userProfile,
    this.sessionData,
  });

  final Exercise exercise;
  final UserProfile? userProfile;
  final Map<String, dynamic>? sessionData;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecoveryTimeParams &&
        other.exercise.id == exercise.id &&
        other.userProfile?.id == userProfile?.id &&
        other.sessionData == sessionData;
  }

  @override
  int get hashCode {
    return exercise.id.hashCode ^
        (userProfile?.id.hashCode ?? 0) ^
        (sessionData?.hashCode ?? 0);
  }
}
