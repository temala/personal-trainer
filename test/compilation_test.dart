import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_training_app/shared/data/services/exercise_database_service.dart';
import 'package:fitness_training_app/shared/data/services/exercise_search_service.dart';
import 'package:fitness_training_app/shared/data/services/exercise_alternative_service.dart';
import 'package:fitness_training_app/shared/data/repositories/firebase_exercise_repository.dart';

void main() {
  group('Compilation Tests', () {
    test('Services can be instantiated', () {
      final databaseService = ExerciseDatabaseService();
      expect(databaseService, isNotNull);

      final repository = FirebaseExerciseRepository();
      expect(repository, isNotNull);

      final searchService = ExerciseSearchService(
        exerciseRepository: repository,
      );
      expect(searchService, isNotNull);

      final alternativeService = ExerciseAlternativeService(
        exerciseRepository: repository,
        searchService: searchService,
      );
      expect(alternativeService, isNotNull);
    });
  });
}
