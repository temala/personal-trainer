import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/shared/data/services/exercise_search_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/presentation/providers/exercise_providers.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';

/// Widget for displaying and selecting exercise alternatives
class ExerciseAlternativesWidget extends ConsumerWidget {
  const ExerciseAlternativesWidget({
    required this.originalExercise,
    required this.userId,
    required this.onAlternativeSelected,
    this.onKeepOriginal,
    this.alternativeType = AlternativeType.similar,
    super.key,
  });

  final Exercise originalExercise;
  final String userId;
  final void Function(Exercise alternative) onAlternativeSelected;
  final VoidCallback? onKeepOriginal;
  final AlternativeType alternativeType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alternativesAsync = ref.watch(
      smartExerciseAlternativesProvider(
        SmartAlternativesParams(
          exerciseId: originalExercise.id,
          userId: userId,
          type: alternativeType,
          limit: 5,
        ),
      ),
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildOriginalExercise(context),
            const SizedBox(height: 16),
            Text(
              'Alternative Exercises',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            alternativesAsync.when(
              data:
                  (alternatives) =>
                      _buildAlternativesList(context, alternatives),
              loading:
                  () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
              error: (error, stack) => _buildErrorState(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_getAlternativeTypeIcon(), color: AppTheme.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getAlternativeTypeTitle(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                _getAlternativeTypeDescription(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOriginalExercise(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getCategoryColor(originalExercise.category),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              originalExercise.category.name.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  originalExercise.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${originalExercise.formattedDuration} • ${originalExercise.difficulty.name}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onKeepOriginal != null)
            TextButton(
              onPressed: onKeepOriginal,
              child: const Text('Keep This'),
            ),
        ],
      ),
    );
  }

  Widget _buildAlternativesList(
    BuildContext context,
    List<Exercise> alternatives,
  ) {
    if (alternatives.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children:
          alternatives
              .map((exercise) => _buildAlternativeItem(context, exercise))
              .toList(),
    );
  }

  Widget _buildAlternativeItem(BuildContext context, Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onAlternativeSelected(exercise),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(exercise.category),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  exercise.category.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      exercise.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 14,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              exercise.formattedDuration,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                              exercise.difficulty,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            exercise.difficulty.name,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getDifficultyColor(exercise.difficulty),
                            ),
                          ),
                        ),
                        if (exercise.equipment.isEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.home,
                                size: 14,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'No equipment',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No Alternatives Found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
          const SizedBox(height: 16),
          Text(
            'Error Loading Alternatives',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We couldn\'t load alternative exercises right now. Please try again later.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getAlternativeTypeIcon() {
    switch (alternativeType) {
      case AlternativeType.similar:
        return Icons.compare_arrows;
      case AlternativeType.easier:
        return Icons.trending_down;
      case AlternativeType.harder:
        return Icons.trending_up;
      case AlternativeType.noEquipment:
        return Icons.home;
    }
  }

  String _getAlternativeTypeTitle() {
    switch (alternativeType) {
      case AlternativeType.similar:
        return 'Similar Exercises';
      case AlternativeType.easier:
        return 'Easier Alternatives';
      case AlternativeType.harder:
        return 'More Challenging';
      case AlternativeType.noEquipment:
        return 'No Equipment Needed';
    }
  }

  String _getAlternativeTypeDescription() {
    switch (alternativeType) {
      case AlternativeType.similar:
        return 'Exercises that target the same muscle groups';
      case AlternativeType.easier:
        return 'Simpler versions you can do right now';
      case AlternativeType.harder:
        return 'More challenging exercises for you';
      case AlternativeType.noEquipment:
        return 'Bodyweight exercises you can do anywhere';
    }
  }

  String _getEmptyStateMessage() {
    switch (alternativeType) {
      case AlternativeType.similar:
        return 'We couldn\'t find similar exercises right now. You can keep the current exercise or skip it.';
      case AlternativeType.easier:
        return 'We couldn\'t find easier alternatives. You can try the current exercise or skip it.';
      case AlternativeType.harder:
        return 'We couldn\'t find more challenging exercises. You can keep the current exercise or skip it.';
      case AlternativeType.noEquipment:
        return 'We couldn\'t find equipment-free alternatives. You can keep the current exercise or skip it.';
    }
  }

  Color _getCategoryColor(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.cardio:
        return Colors.red;
      case ExerciseCategory.strength:
        return Colors.blue;
      case ExerciseCategory.flexibility:
        return Colors.green;
      case ExerciseCategory.balance:
        return Colors.orange;
      case ExerciseCategory.sports:
        return Colors.purple;
      case ExerciseCategory.rehabilitation:
        return Colors.teal;
    }
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return Colors.green;
      case DifficultyLevel.intermediate:
        return Colors.orange;
      case DifficultyLevel.advanced:
        return Colors.red;
      case DifficultyLevel.expert:
        return Colors.purple;
    }
  }
}
