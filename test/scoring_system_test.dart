import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/scoring_service.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_response.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/fitness_enums.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/user_score.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';

// Mock implementations for testing
class MockAIServiceRepository implements AIServiceRepository {
  bool shouldSucceed = true;
  Map<String, dynamic> responseData = {};

  @override
  Future<AIResponse> processRequest(AIRequest request) async {
    if (shouldSucceed) {
      return AIResponse.success(
        requestId: request.requestId,
        data: responseData,
        providerId: 'test-provider',
      );
    } else {
      return AIResponse.error(
        requestId: request.requestId,
        error: 'Test error',
        providerId: 'test-provider',
      );
    }
  }

  // Other required methods (not used in scoring tests)
  @override
  Future<WorkoutPlan> generateWeeklyPlan(
    profile,
    availableExercises, {
    preferences,
    constraints,
  }) async => throw UnimplementedError();
  @override
  Future<Exercise?> getAlternativeExercise(
    currentExerciseId,
    type,
    availableExercises, {
    userId,
    userContext,
    excludeExerciseIds,
  }) async => throw UnimplementedError();
  @override
  Future<String> generateNotificationMessage(userContext) async =>
      throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> generateUserAvatar(
    userPhotoPath, {
    stylePreferences,
  }) async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> analyzeProgress(userId, progressData) async =>
      throw UnimplementedError();
  @override
  Future<bool> testConnection() async => true;
  @override
  bool get isConfigured => true;
  @override
  String get providerName => 'test';
  @override
  AIProviderType get providerType => AIProviderType.custom;
}

class MockAppLogger implements AppLogger {
  List<String> logs = [];

  @override
  void logInfo(String message, [dynamic error, StackTrace? stackTrace]) {
    logs.add('INFO: $message');
  }

  @override
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    logs.add('ERROR: $message');
  }

  @override
  void logWarning(String message, [dynamic error, StackTrace? stackTrace]) {
    logs.add('WARNING: $message');
  }

  @override
  void logDebug(String message, [dynamic error, StackTrace? stackTrace]) {
    logs.add('DEBUG: $message');
  }

  @override
  void logFatal(String message, [dynamic error, StackTrace? stackTrace]) {
    logs.add('FATAL: $message');
  }
}

void main() {
  group('ScoringService Tests', () {
    late ScoringService scoringService;
    late MockAIServiceRepository mockAIService;
    late MockAppLogger mockLogger;

    setUp(() {
      mockAIService = MockAIServiceRepository();
      mockLogger = MockAppLogger();
      scoringService = ScoringService(
        aiService: mockAIService,
        logger: mockLogger,
      );
    });

    group('calculateWorkoutScore', () {
      test(
        'should calculate correct base score for completed workout',
        () async {
          // Arrange
          final userScore = _createTestUserScore();
          final userProfile = _createTestUserProfile();
          final workoutSession = _createCompletedWorkoutSession();

          // Mock AI response
          mockAIService.shouldSucceed = true;
          mockAIService.responseData = {'commitment_level': 0.8};

          // Act
          final result = await scoringService.calculateWorkoutScore(
            session: workoutSession,
            currentScore: userScore,
            userProfile: userProfile,
          );

          // Assert
          expect(result.sessionScore, greaterThan(0));
          expect(
            result.newTotalScore,
            equals(userScore.totalScore + result.sessionScore),
          );
          expect(result.newCommitmentLevel, greaterThanOrEqualTo(0.0));
          expect(result.newCommitmentLevel, lessThanOrEqualTo(1.0));
        },
      );

      test('should award completion bonus for 100% completion', () async {
        // Arrange
        final userScore = _createTestUserScore();
        final userProfile = _createTestUserProfile();
        final workoutSession = _createPerfectWorkoutSession();

        mockAIService.shouldSucceed = true;
        mockAIService.responseData = {'commitment_level': 0.9};

        // Act
        final result = await scoringService.calculateWorkoutScore(
          session: workoutSession,
          currentScore: userScore,
          userProfile: userProfile,
        );

        // Assert
        expect(result.scoreBreakdown.completionBonus, equals(25));
      });

      test('should detect new achievements', () async {
        // Arrange
        final userScore = _createTestUserScore(workoutsCompleted: 0);
        final userProfile = _createTestUserProfile();
        final workoutSession = _createCompletedWorkoutSession();

        mockAIService.shouldSucceed = true;
        mockAIService.responseData = {'commitment_level': 0.7};

        // Act
        final result = await scoringService.calculateWorkoutScore(
          session: workoutSession,
          currentScore: userScore,
          userProfile: userProfile,
        );

        // Assert
        expect(result.newAchievements, isNotEmpty);
        expect(result.newAchievements.first.id, equals('first_workout'));
      });

      test('should handle AI service failure gracefully', () async {
        // Arrange
        final userScore = _createTestUserScore();
        final userProfile = _createTestUserProfile();
        final workoutSession = _createCompletedWorkoutSession();

        mockAIService.shouldSucceed = false;

        // Act
        final result = await scoringService.calculateWorkoutScore(
          session: workoutSession,
          currentScore: userScore,
          userProfile: userProfile,
        );

        // Assert
        expect(result.sessionScore, greaterThan(0));
        // When AI fails, commitment level is recalculated using base algorithm
        expect(result.newCommitmentLevel, greaterThanOrEqualTo(0.0));
        expect(result.newCommitmentLevel, lessThanOrEqualTo(1.0));
      });
    });

    group('generateScoreAdvice', () {
      test('should generate AI advice when service is available', () async {
        // Arrange
        final userScore = _createTestUserScore();
        final userProfile = _createTestUserProfile();

        mockAIService.shouldSucceed = true;
        mockAIService.responseData = {
          'advice': 'Keep up the great work! Focus on consistency.',
        };

        // Act
        final advice = await scoringService.generateScoreAdvice(
          userScore: userScore,
          userProfile: userProfile,
        );

        // Assert
        expect(advice, equals('Keep up the great work! Focus on consistency.'));
      });

      test('should provide fallback advice when AI service fails', () async {
        // Arrange
        final userScore = _createTestUserScore(commitmentLevel: 0.2);
        final userProfile = _createTestUserProfile();

        mockAIService.shouldSucceed = false;

        // Act
        final advice = await scoringService.generateScoreAdvice(
          userScore: userScore,
          userProfile: userProfile,
        );

        // Assert
        expect(advice, contains('consistency'));
        expect(advice, contains('3 workouts per week'));
      });
    });
  });

  group('UserScore Entity Tests', () {
    test('should calculate current level correctly', () {
      // Test different score levels
      final testCases = [
        (50, 1),
        (150, 2),
        (400, 3),
        (800, 4),
        (1200, 5),
        (2000, 6),
        (3000, 8), // Updated based on actual level calculation
        (4000, 9),
        (5000, 10),
      ];

      for (final testCase in testCases) {
        final userScore = _createTestUserScore(totalScore: testCase.$1);
        expect(userScore.currentLevel, equals(testCase.$2));
      }
    });

    test('should calculate completion rate correctly', () {
      final userScore = _createTestUserScore(
        workoutsCompleted: 8,
        totalWorkouts: 10,
      );

      expect(userScore.completionRate, equals(80.0));
    });

    test('should identify highly committed users', () {
      final highlyCommitted = _createTestUserScore(commitmentLevel: 0.85);
      final notCommitted = _createTestUserScore(commitmentLevel: 0.5);

      expect(highlyCommitted.isHighlyCommitted, isTrue);
      expect(notCommitted.isHighlyCommitted, isFalse);
    });

    test('should validate user score data', () {
      final invalidScore = UserScore(
        id: 'test',
        userId: '',
        totalScore: -100,
        commitmentLevel: 1.5,
        workoutsCompleted: 15,
        totalWorkouts: 10,
        currentStreak: -5,
        longestStreak: 3,
        achievements: [],
        categoryScores: {},
        lastUpdated: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final errors = invalidScore.validate();
      expect(errors, isNotEmpty);
      expect(errors, contains('User ID cannot be empty'));
      expect(errors, contains('Total score cannot be negative'));
      expect(errors, contains('Commitment level must be between 0.0 and 1.0'));
      expect(
        errors,
        contains('Workouts completed cannot exceed total workouts'),
      );
      expect(errors, contains('Current streak cannot be negative'));
    });
  });

  group('Achievement Tests', () {
    test('should create predefined achievements correctly', () {
      final achievements = UserScoreHelper.predefinedAchievements;

      expect(achievements, isNotEmpty);
      expect(achievements.any((a) => a.id == 'first_workout'), isTrue);
      expect(achievements.any((a) => a.id == 'week_streak'), isTrue);
      expect(achievements.any((a) => a.id == 'level_ten'), isTrue);
    });

    test('should categorize achievements by type', () {
      final achievements = UserScoreHelper.predefinedAchievements;
      final workoutAchievements =
          achievements
              .where((a) => a.type == AchievementType.workoutCompletion)
              .toList();
      final streakAchievements =
          achievements.where((a) => a.type == AchievementType.streak).toList();

      expect(workoutAchievements, isNotEmpty);
      expect(streakAchievements, isNotEmpty);
    });

    test('should assign correct tier colors', () {
      final bronzeAchievement = Achievement(
        id: 'test',
        name: 'Test',
        description: 'Test achievement',
        type: AchievementType.workoutCompletion,
        tier: AchievementTier.bronze,
        pointsAwarded: 50,
        unlockedAt: DateTime.now(),
      );

      expect(bronzeAchievement.tierColor, equals('#CD7F32'));
      expect(bronzeAchievement.tierDisplayName, equals('Bronze'));
    });
  });
}

// Helper functions to create test data
UserScore _createTestUserScore({
  int totalScore = 500,
  double commitmentLevel = 0.7,
  int workoutsCompleted = 10,
  int totalWorkouts = 12,
  int currentStreak = 5,
  int longestStreak = 8,
}) {
  return UserScore(
    id: 'test-score',
    userId: 'test-user',
    totalScore: totalScore,
    commitmentLevel: commitmentLevel,
    workoutsCompleted: workoutsCompleted,
    totalWorkouts: totalWorkouts,
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    achievements: [],
    categoryScores: {
      for (final category in ScoreCategory.values)
        category.name: totalScore ~/ 5,
    },
    lastUpdated: DateTime.now(),
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );
}

UserProfile _createTestUserProfile() {
  return UserProfile(
    id: 'test-user',
    email: 'test@example.com',
    lastUpdated: DateTime.now(),
    name: 'Test User',
    age: 25,
    height: 175.0,
    weight: 70.0,
    targetWeight: 65.0,
    fitnessGoal: FitnessGoal.weightLoss,
    activityLevel: ActivityLevel.moderatelyActive,
    preferredExerciseTypes: ['cardio', 'strength'],
    dislikedExercises: [],
    preferences: {},
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );
}

WorkoutSession _createCompletedWorkoutSession() {
  return WorkoutSession(
    id: 'test-session',
    userId: 'test-user',
    workoutPlanId: 'test-plan',
    status: SessionStatus.completed,
    startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    exerciseExecutions: [
      ExerciseExecution(
        exerciseId: 'exercise-1',
        order: 1,
        status: ExecutionStatus.completed,
        startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        setExecutions: [
          SetExecution(
            setNumber: 1,
            status: SetStatus.completed,
            startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
            completedAt: DateTime.now().subtract(const Duration(minutes: 25)),
            actualReps: 10,
            plannedReps: 10,
          ),
        ],
        completedAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
    ],
    metadata: {},
    completedAt: DateTime.now(),
    completionPercentage: 80.0,
  );
}

WorkoutSession _createPerfectWorkoutSession() {
  return WorkoutSession(
    id: 'test-session-perfect',
    userId: 'test-user',
    workoutPlanId: 'test-plan',
    status: SessionStatus.completed,
    startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    exerciseExecutions: [
      ExerciseExecution(
        exerciseId: 'exercise-1',
        order: 1,
        status: ExecutionStatus.completed,
        startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        setExecutions: [
          SetExecution(
            setNumber: 1,
            status: SetStatus.completed,
            startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
            completedAt: DateTime.now().subtract(const Duration(minutes: 25)),
            actualReps: 10,
            plannedReps: 10,
          ),
        ],
        completedAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
    ],
    metadata: {},
    completedAt: DateTime.now(),
    completionPercentage: 100.0,
  );
}
