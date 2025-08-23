import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';
import 'package:fitness_training_app/shared/data/models/ai_provider_config.dart';
import 'package:fitness_training_app/core/errors/ai_service_error.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:logger/logger.dart';

class ChatGPTProvider implements AIServiceRepository {
  final AIProviderConfig _config;
  final http.Client _httpClient;
  final Logger _logger;

  ChatGPTProvider({
    required AIProviderConfig config,
    http.Client? httpClient,
    Logger? logger,
  }) : _config = config,
       _httpClient = httpClient ?? http.Client(),
       _logger = logger ?? Logger();

  @override
  String get providerName => 'ChatGPT';

  @override
  AIProviderType get providerType => AIProviderType.chatgpt;

  @override
  bool get isConfigured => _config.apiKey.isNotEmpty;

  String get _baseUrl => _config.baseUrl ?? 'https://api.openai.com/v1';
  String get _model => _config.model ?? 'gpt-4';

  @override
  Future<WorkoutPlan> generateWeeklyPlan(
    UserProfile profile,
    List<Exercise> availableExercises, {
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? constraints,
  }) async {
    if (!isConfigured) {
      throw AIServiceError('ChatGPT provider not configured');
    }

    try {
      final prompt = _buildWorkoutPlanPrompt(
        profile,
        availableExercises,
        preferences,
        constraints,
      );

      final response = await _makeRequest(prompt);
      return _parseWorkoutPlanResponse(response, profile.id);
    } catch (e) {
      _logger.e('Failed to generate workout plan: $e');
      throw AIServiceError('Failed to generate workout plan: ${e.toString()}');
    }
  }

  @override
  Future<Exercise?> getAlternativeExercise(
    String currentExerciseId,
    AlternativeType type,
    List<Exercise> availableExercises, {
    String? userId,
    Map<String, dynamic>? userContext,
    List<String>? excludeExerciseIds,
  }) async {
    if (!isConfigured) {
      throw AIServiceError('ChatGPT provider not configured');
    }

    try {
      final currentExercise = availableExercises.firstWhere(
        (e) => e.id == currentExerciseId,
      );

      final prompt = _buildAlternativeExercisePrompt(
        currentExercise,
        type,
        availableExercises,
        userContext,
        excludeExerciseIds,
      );

      final response = await _makeRequest(prompt);
      return _parseAlternativeExerciseResponse(response, availableExercises);
    } catch (e) {
      _logger.e('Failed to get alternative exercise: $e');
      return null; // Return null instead of throwing to allow graceful fallback
    }
  }

  @override
  Future<String> generateNotificationMessage(
    Map<String, dynamic> userContext,
  ) async {
    if (!isConfigured) {
      throw AIServiceError('ChatGPT provider not configured');
    }

    try {
      final prompt = _buildNotificationPrompt(userContext);
      final response = await _makeRequest(prompt);
      return _parseNotificationResponse(response);
    } catch (e) {
      _logger.e('Failed to generate notification message: $e');
      throw AIServiceError('Failed to generate notification: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> generateUserAvatar(
    String userPhotoPath, {
    Map<String, dynamic>? stylePreferences,
  }) async {
    // Avatar generation requires image processing capabilities
    // This would typically use DALL-E or similar image generation API
    throw UnimplementedError(
      'Avatar generation not implemented for ChatGPT provider',
    );
  }

  @override
  Future<Map<String, dynamic>> analyzeProgress(
    String userId,
    Map<String, dynamic> progressData,
  ) async {
    if (!isConfigured) {
      throw AIServiceError('ChatGPT provider not configured');
    }

    try {
      final prompt = _buildProgressAnalysisPrompt(progressData);
      final response = await _makeRequest(prompt);
      return _parseProgressAnalysisResponse(response);
    } catch (e) {
      _logger.e('Failed to analyze progress: $e');
      throw AIServiceError('Failed to analyze progress: ${e.toString()}');
    }
  }

  @override
  Future<bool> testConnection() async {
    if (!isConfigured) return false;

    try {
      final response = await _makeRequest(
        'Respond with "OK" if you can receive this message.',
        maxTokens: 10,
      );
      return response.toLowerCase().contains('ok');
    } catch (e) {
      _logger.e('Connection test failed: $e');
      return false;
    }
  }

  Future<String> _makeRequest(
    String prompt, {
    int? maxTokens,
    double? temperature,
  }) async {
    final url = Uri.parse('$_baseUrl/chat/completions');

    final body = {
      'model': _model,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a fitness AI assistant that helps create personalized workout plans and provides exercise alternatives. Always respond with valid JSON when requested.',
        },
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': maxTokens ?? _config.additionalConfig['maxTokens'] ?? 2000,
      'temperature':
          temperature ?? _config.additionalConfig['temperature'] ?? 0.7,
    };

    final response = await _httpClient
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_config.apiKey}',
          },
          body: json.encode(body),
        )
        .timeout(Duration(seconds: _config.timeoutSeconds));

    if (response.statusCode != 200) {
      throw AIServiceError(
        'ChatGPT API error: ${response.statusCode} - ${response.body}',
      );
    }

    final responseData = json.decode(response.body);
    final content = responseData['choices']?[0]?['message']?['content'];

    if (content == null) {
      throw AIServiceError('Invalid response format from ChatGPT API');
    }

    return content as String;
  }

  String _buildWorkoutPlanPrompt(
    UserProfile profile,
    List<Exercise> availableExercises,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? constraints,
  ) {
    final exerciseList =
        availableExercises
            .map(
              (e) => {
                'id': e.id,
                'name': e.name,
                'category': e.category.name,
                'difficulty': e.difficulty.name,
                'duration': e.estimatedDurationSeconds,
                'equipment': e.equipment,
              },
            )
            .toList();

    return '''
Create a personalized weekly workout plan for a user with the following profile:
- Age: ${profile.age}
- Height: ${profile.height}cm
- Current Weight: ${profile.weight}kg
- Target Weight: ${profile.targetWeight}kg
- Fitness Goal: ${profile.fitnessGoal.name}
- Activity Level: ${profile.activityLevel.name}

Available exercises (you MUST only select from these):
${json.encode(exerciseList)}

User preferences: ${json.encode(preferences ?? {})}
Constraints: ${json.encode(constraints ?? {})}

Please respond with a JSON object in this exact format:
{
  "weeklyPlan": [
    {
      "dayOfWeek": 1,
      "exercises": [
        {
          "exerciseId": "exercise_id_from_available_list",
          "sets": 3,
          "reps": 12,
          "duration": 30,
          "restTime": 60
        }
      ],
      "totalDuration": 1800,
      "difficulty": "beginner"
    }
  ],
  "totalWeeklyDuration": 7200,
  "focusAreas": ["strength", "cardio"],
  "notes": "Personalized advice for the user"
}

Ensure all exerciseId values exist in the provided available exercises list.
''';
  }

  String _buildAlternativeExercisePrompt(
    Exercise currentExercise,
    AlternativeType type,
    List<Exercise> availableExercises,
    Map<String, dynamic>? userContext,
    List<String>? excludeExerciseIds,
  ) {
    final exerciseList =
        availableExercises
            .where((e) => e.id != currentExercise.id)
            .where((e) => !(excludeExerciseIds?.contains(e.id) ?? false))
            .map(
              (e) => {
                'id': e.id,
                'name': e.name,
                'category': e.category.name,
                'difficulty': e.difficulty.name,
                'duration': e.estimatedDurationSeconds,
                'equipment': e.equipment,
              },
            )
            .toList();

    final reasonMap = {
      AlternativeType.dontLike: 'user doesn\'t like this exercise',
      AlternativeType.notPossibleNow: 'user can\'t do this exercise right now',
      AlternativeType.tooEasy: 'exercise is too easy for the user',
      AlternativeType.tooHard: 'exercise is too hard for the user',
      AlternativeType.noEquipment: 'user doesn\'t have required equipment',
    };

    return '''
The user is currently doing this exercise:
${json.encode({'id': currentExercise.id, 'name': currentExercise.name, 'category': currentExercise.category.name, 'difficulty': currentExercise.difficulty.name, 'equipment': currentExercise.equipment})}

Reason for alternative: ${reasonMap[type]}
User context: ${json.encode(userContext ?? {})}

Available alternative exercises (you MUST only select from these):
${json.encode(exerciseList)}

Please respond with a JSON object containing the best alternative exercise:
{
  "exerciseId": "selected_exercise_id_from_available_list",
  "reason": "Brief explanation why this is a good alternative"
}

If no suitable alternative exists, respond with:
{
  "exerciseId": null,
  "reason": "No suitable alternative found"
}
''';
  }

  String _buildNotificationPrompt(Map<String, dynamic> userContext) {
    return '''
Generate a personalized, motivational fitness notification message for a user with this context:
${json.encode(userContext)}

The message should be:
- Encouraging and positive
- Personalized based on the user's context
- Brief (under 100 characters for push notifications)
- Action-oriented

Respond with just the message text, no JSON formatting.
''';
  }

  String _buildProgressAnalysisPrompt(Map<String, dynamic> progressData) {
    return '''
Analyze this user's fitness progress data and provide insights:
${json.encode(progressData)}

Please respond with a JSON object:
{
  "overallScore": 85,
  "commitmentLevel": "high",
  "strengths": ["consistency", "improvement in cardio"],
  "areasForImprovement": ["strength training frequency"],
  "recommendations": ["Increase strength training to 3x per week"],
  "motivationalMessage": "Great progress! Keep up the excellent work!"
}
''';
  }

  WorkoutPlan _parseWorkoutPlanResponse(String response, String userId) {
    try {
      final data = json.decode(response);
      final weeklyPlan = data['weeklyPlan'] as List;

      final exercises = <WorkoutExercise>[];
      var order = 1;

      for (final day in weeklyPlan) {
        final dayExercises = (day['exercises'] as List);
        for (final ex in dayExercises) {
          exercises.add(
            WorkoutExercise(
              exerciseId: ex['exerciseId'] as String,
              order: order++,
              sets: ex['sets'] as int? ?? 1,
              repsPerSet: ex['reps'] as int? ?? 1,
              restBetweenSetsSeconds: ex['restTime'] as int? ?? 60,
            ),
          );
        }
      }

      return WorkoutPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'AI Generated Workout Plan',
        description:
            data['notes'] as String? ??
            'Personalized workout plan generated by AI',
        exercises: exercises,
        type: WorkoutType.mixed,
        difficulty: DifficultyLevel.beginner,
        estimatedDurationMinutes:
            (data['totalWeeklyDuration'] as int? ?? 0) ~/ 60,
        targetMuscleGroups: (data['focusAreas'] as List?)?.cast<String>() ?? [],
        metadata: {
          'aiGenerated': true,
          'generatedAt': DateTime.now().toIso8601String(),
          'userId': userId,
        },
        userId: userId,
        aiGeneratedBy: 'ChatGPT',
        aiGenerationContext: data as Map<String, dynamic>?,
        isTemplate: false,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw AIServiceError(
        'Failed to parse workout plan response: ${e.toString()}',
      );
    }
  }

  Exercise? _parseAlternativeExerciseResponse(
    String response,
    List<Exercise> availableExercises,
  ) {
    try {
      final data = json.decode(response);
      final exerciseId = data['exerciseId'] as String?;

      if (exerciseId == null) return null;

      return availableExercises.firstWhere(
        (e) => e.id == exerciseId,
        orElse:
            () =>
                throw AIServiceError(
                  'Alternative exercise not found in database',
                ),
      );
    } catch (e) {
      _logger.e('Failed to parse alternative exercise response: $e');
      return null;
    }
  }

  String _parseNotificationResponse(String response) {
    // Response should be plain text, not JSON
    return response.trim();
  }

  Map<String, dynamic> _parseProgressAnalysisResponse(String response) {
    try {
      return json.decode(response) as Map<String, dynamic>;
    } catch (e) {
      throw AIServiceError(
        'Failed to parse progress analysis response: ${e.toString()}',
      );
    }
  }
}
