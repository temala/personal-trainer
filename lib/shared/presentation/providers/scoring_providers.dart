import 'package:fitness_training_app/shared/data/repositories/ai_service_repository_adapter.dart';
import 'package:fitness_training_app/shared/data/repositories/firebase_user_score_repository.dart';
import 'package:fitness_training_app/shared/data/services/scoring_service.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/user_score.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/domain/repositories/user_score_repository.dart';
import 'package:fitness_training_app/shared/presentation/providers/ai_providers.dart';
import 'package:fitness_training_app/shared/presentation/providers/firebase_providers.dart';
import 'package:fitness_training_app/shared/presentation/providers/logger_providers.dart';
import 'package:fitness_training_app/shared/presentation/providers/offline_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for UserScoreRepository
final userScoreRepositoryProvider = Provider<UserScoreRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final offlineManager = ref.watch(offlineManagerProvider);

  return FirebaseUserScoreRepository(
    firestore: firestore,
    offlineManager: offlineManager,
  );
});

/// Provider for ScoringService
final scoringServiceProvider = Provider<ScoringService>((ref) {
  final aiProviderManager = ref.watch(aiProviderManagerProvider);
  final aiServiceRepository = AIServiceRepositoryAdapter(aiProviderManager);
  final logger = ref.watch(loggerProvider);

  return ScoringService(aiService: aiServiceRepository, logger: logger);
});

/// Provider for current user's score
final userScoreProvider = StreamProvider.family<UserScore?, String>((
  ref,
  userId,
) {
  final repository = ref.watch(userScoreRepositoryProvider);
  return repository.watchUserScore(userId);
});

/// Provider for user score state (with loading and error handling)
final userScoreStateProvider = StateNotifierProvider.family<
  UserScoreNotifier,
  AsyncValue<UserScore?>,
  String
>((ref, userId) {
  final repository = ref.watch(userScoreRepositoryProvider);
  final scoringService = ref.watch(scoringServiceProvider);

  return UserScoreNotifier(
    userId: userId,
    repository: repository,
    scoringService: scoringService,
  );
});

/// Provider for leaderboard (top scores)
final leaderboardProvider = FutureProvider.family<List<UserScore>, int>((
  ref,
  limit,
) async {
  final repository = ref.watch(userScoreRepositoryProvider);
  return repository.getTopScores(limit: limit);
});

/// Provider for user rank
final userRankProvider = FutureProvider.family<int, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(userScoreRepositoryProvider);
  return repository.getUserRank(userId);
});

/// Provider for similar scores
final similarScoresProvider = FutureProvider.family<List<UserScore>, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(userScoreRepositoryProvider);
  return repository.getSimilarScores(userId);
});

/// Provider for AI-generated score advice
final scoreAdviceProvider = FutureProvider.family<String, ScoreAdviceParams>((
  ref,
  params,
) async {
  final scoringService = ref.watch(scoringServiceProvider);
  return scoringService.generateScoreAdvice(
    userScore: params.userScore,
    userProfile: params.userProfile,
  );
});

/// Provider for achievement statistics
final achievementStatisticsProvider = FutureProvider<Map<String, int>>((
  ref,
) async {
  final repository = ref.watch(userScoreRepositoryProvider);
  return repository.getAchievementStatistics();
});

/// State notifier for managing user score state
class UserScoreNotifier extends StateNotifier<AsyncValue<UserScore?>> {
  UserScoreNotifier({
    required this.userId,
    required UserScoreRepository repository,
    required ScoringService scoringService,
  }) : _repository = repository,
       _scoringService = scoringService,
       super(const AsyncValue.loading()) {
    _loadUserScore();
  }

  final String userId;
  final UserScoreRepository _repository;
  final ScoringService _scoringService;

  /// Load user score
  Future<void> _loadUserScore() async {
    try {
      state = const AsyncValue.loading();
      final userScore = await _repository.getUserScore(userId);

      if (userScore == null) {
        // Create initial score for new user
        final initialScore = UserScoreHelper.createInitial(userId: userId);
        await _repository.saveUserScore(initialScore.copyWith(id: userId));
        state = AsyncValue.data(initialScore.copyWith(id: userId));
      } else {
        state = AsyncValue.data(userScore);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh user score
  Future<void> refresh() async {
    await _loadUserScore();
  }

  /// Update score after workout completion
  Future<void> updateScoreAfterWorkout({
    required WorkoutSession session,
    required UserProfile userProfile,
  }) async {
    try {
      final currentScore = state.value;
      if (currentScore == null) return;

      // Calculate score update
      final scoreUpdate = await _scoringService.calculateWorkoutScore(
        session: session,
        currentScore: currentScore,
        userProfile: userProfile,
      );

      // Create updated score
      final updatedScore = currentScore.copyWith(
        totalScore: scoreUpdate.newTotalScore,
        commitmentLevel: scoreUpdate.newCommitmentLevel,
        workoutsCompleted: currentScore.workoutsCompleted + 1,
        totalWorkouts: currentScore.totalWorkouts + 1,
        currentStreak: scoreUpdate.currentStreak,
        longestStreak: scoreUpdate.longestStreak,
        achievements: [
          ...currentScore.achievements,
          ...scoreUpdate.newAchievements,
        ],
        categoryScores: scoreUpdate.updatedCategoryScores,
        lastUpdated: DateTime.now(),
        recentAchievements:
            scoreUpdate.newAchievements.map((a) => a.id).toList(),
        progressMetrics: {
          ...currentScore.progressMetrics ?? {},
          'lastSessionScore': scoreUpdate.sessionScore,
          'lastScoreBreakdown': {
            'baseScore': scoreUpdate.scoreBreakdown.baseScore,
            'completionBonus': scoreUpdate.scoreBreakdown.completionBonus,
            'consistencyBonus': scoreUpdate.scoreBreakdown.consistencyBonus,
            'difficultyBonus': scoreUpdate.scoreBreakdown.difficultyBonus,
            'efficiencyBonus': scoreUpdate.scoreBreakdown.efficiencyBonus,
          },
        },
      );

      // Save to repository
      await _repository.saveUserScore(updatedScore);

      // Update state
      state = AsyncValue.data(updatedScore);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Add achievement manually (for testing or special cases)
  Future<void> addAchievement(Achievement achievement) async {
    try {
      final currentScore = state.value;
      if (currentScore == null) return;

      final updatedScore = currentScore.copyWith(
        achievements: [...currentScore.achievements, achievement],
        totalScore: currentScore.totalScore + achievement.pointsAwarded,
        lastUpdated: DateTime.now(),
        recentAchievements: [achievement.id],
      );

      await _repository.saveUserScore(updatedScore);
      state = AsyncValue.data(updatedScore);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update commitment level manually
  Future<void> updateCommitmentLevel(double newLevel) async {
    try {
      final currentScore = state.value;
      if (currentScore == null) return;

      final updatedScore = currentScore.copyWith(
        commitmentLevel: newLevel.clamp(0.0, 1.0),
        lastUpdated: DateTime.now(),
      );

      await _repository.saveUserScore(updatedScore);
      state = AsyncValue.data(updatedScore);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Reset user score (for testing)
  Future<void> resetScore() async {
    try {
      await _repository.resetUserScore(userId);
      await _loadUserScore();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update periodic scores
  Future<void> updatePeriodicScores({
    int? weeklyScore,
    int? monthlyScore,
  }) async {
    try {
      await _repository.updatePeriodicScores(
        userId,
        weeklyScore: weeklyScore,
        monthlyScore: monthlyScore,
      );

      // Refresh to get updated data
      await refresh();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Parameters for score advice provider
@immutable
class ScoreAdviceParams {
  ScoreAdviceParams({required this.userScore, required this.userProfile});

  final UserScore userScore;
  final UserProfile userProfile;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreAdviceParams &&
          runtimeType == other.runtimeType &&
          userScore.id == other.userScore.id &&
          userProfile.id == other.userProfile.id &&
          userScore.lastUpdated == other.userScore.lastUpdated;

  @override
  int get hashCode =>
      userScore.id.hashCode ^
      userProfile.id.hashCode ^
      userScore.lastUpdated.hashCode;
}

/// Provider for background score updates
final backgroundScoreUpdateProvider = Provider<BackgroundScoreUpdater>((ref) {
  final scoringService = ref.watch(scoringServiceProvider);
  final repository = ref.watch(userScoreRepositoryProvider);

  return BackgroundScoreUpdater(
    scoringService: scoringService,
    repository: repository,
  );
});

/// Service for handling background score updates
class BackgroundScoreUpdater {
  BackgroundScoreUpdater({
    required ScoringService scoringService,
    required UserScoreRepository repository,
  }) : _scoringService = scoringService,
       _repository = repository;

  final ScoringService _scoringService;
  final UserScoreRepository _repository;

  /// Update score in background after workout
  Future<void> updateScoreInBackground({
    required String userId,
    required WorkoutSession session,
    required UserProfile userProfile,
  }) async {
    await _scoringService.updateScoreInBackground(
      userId: userId,
      session: session,
      onScoreUpdated: (updatedScore) async {
        await _repository.saveUserScore(updatedScore);
      },
    );
  }
}
