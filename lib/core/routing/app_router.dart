import 'package:flutter/material.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/registration_screen.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/profile_setup_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/notification_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/ai_provider_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/privacy_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/account_settings_screen.dart';

/// App router for handling navigation
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/sign-in':
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: settings,
        );

      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegistrationScreen(),
          settings: settings,
        );

      case '/email-verification':
        return MaterialPageRoute(
          builder: (_) => const EmailVerificationScreen(),
          settings: settings,
        );

      case '/forgot-password':
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );

      case '/profile-setup':
        return MaterialPageRoute(
          builder: (_) => const ProfileSetupScreen(),
          settings: settings,
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );

      case '/notification-settings':
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsScreen(),
          settings: settings,
        );

      case '/ai-provider-settings':
        return MaterialPageRoute(
          builder: (_) => const AIProviderSettingsScreen(),
          settings: settings,
        );

      case '/privacy-settings':
        return MaterialPageRoute(
          builder: (_) => const PrivacySettingsScreen(),
          settings: settings,
        );

      case '/account-settings':
        return MaterialPageRoute(
          builder: (_) => const AccountSettingsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
          settings: settings,
        );
    }
  }
}

/// Home screen placeholder
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Map<int, _RoutinePlan> _weeklyPlan = {
    DateTime.monday: _RoutinePlan(
      title: 'Routine 1 — PUSH',
      focus: 'Pecs / Épaules / Triceps + Cardio',
      cardio: 'Intervals 15 min : 30s rapide / 30s lent',
      startTime: '18h30',
      endTime: '20h30',
      exercises: [
        _RoutineExercise(name: 'Bench Press', targetSets: 4, repsRange: '6–10'),
        _RoutineExercise(
          name: 'Incline Dumbbell Press',
          targetSets: 3,
          repsRange: '8–12',
        ),
        _RoutineExercise(
          name: 'Overhead Press',
          targetSets: 4,
          repsRange: '6–10',
        ),
        _RoutineExercise(
          name: 'Lateral Raises',
          targetSets: 3,
          repsRange: '12–15',
        ),
        _RoutineExercise(
          name: 'Triceps Pushdown / Dips',
          targetSets: 3,
          repsRange: '10–12',
        ),
        _RoutineExercise(name: 'Plank', targetSets: 3, repsRange: '45s'),
      ],
    ),
    DateTime.wednesday: _RoutinePlan(
      title: 'Routine 2 — PULL',
      focus: 'Dos / Biceps + Cardio Modéré',
      cardio: 'Zone 2 — 20 min',
      startTime: '18h30',
      endTime: '20h30',
      exercises: [
        _RoutineExercise(
          name: 'Pull-Ups / Lat Pulldown',
          targetSets: 4,
          repsRange: '6–10',
        ),
        _RoutineExercise(name: 'Barbell Row', targetSets: 4, repsRange: '8–12'),
        _RoutineExercise(
          name: 'Seated Cable Row',
          targetSets: 3,
          repsRange: '10–12',
        ),
        _RoutineExercise(name: 'Face Pull', targetSets: 3, repsRange: '12–15'),
        _RoutineExercise(
          name: 'Barbell Curl',
          targetSets: 3,
          repsRange: '8–12',
        ),
        _RoutineExercise(
          name: 'Incline Dumbbell Curl',
          targetSets: 3,
          repsRange: '10–12',
        ),
      ],
    ),
    DateTime.friday: _RoutinePlan(
      title: 'Routine 3 — Upper Full Body',
      focus: 'Upper Body + HIIT',
      cardio: 'HIIT 10–15 min : 20s sprint / 40s repos ×10',
      startTime: '18h30',
      endTime: '20h30',
      exercises: [
        _RoutineExercise(
          name: 'Dumbbell Bench Press',
          targetSets: 3,
          repsRange: '8–12',
        ),
        _RoutineExercise(name: 'Lat Pulldown', targetSets: 3, repsRange: '8–12'),
        _RoutineExercise(name: 'Machine Row', targetSets: 3, repsRange: '10–12'),
        _RoutineExercise(
          name: 'Seated Shoulder Press',
          targetSets: 3,
          repsRange: '8–12',
        ),
        _RoutineExercise(name: 'Dumbbell Curl', targetSets: 3, repsRange: '12'),
        _RoutineExercise(
          name: 'Triceps Extension',
          targetSets: 3,
          repsRange: '12',
        ),
        _RoutineExercise(
          name: 'Cable Crunch / Leg Raises',
          targetSets: 3,
          repsRange: '15',
        ),
      ],
    ),
  };

  final Map<String, _ExerciseEntry> _exerciseEntries = {};
  final Map<String, _PersonalRecord> _personalRecords = {};
  final List<_WorkoutHistoryEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _initializeEntriesForToday();
  }

  @override
  void dispose() {
    for (final entry in _exerciseEntries.values) {
      entry.dispose();
    }
    super.dispose();
  }

  void _initializeEntriesForToday() {
    final routine = _weeklyPlan[DateTime.now().weekday];
    if (routine == null) {
      return;
    }
    for (final exercise in routine.exercises) {
      _exerciseEntries.putIfAbsent(
        exercise.name,
        () => _ExerciseEntry(exerciseName: exercise.name),
      );
    }
  }

  void _saveSession(_RoutinePlan plan) {
    final now = DateTime.now();
    final logs = <_ExerciseLog>[];
    for (final exercise in plan.exercises) {
      final entry = _exerciseEntries[exercise.name];
      if (entry == null) {
        continue;
      }
      final weight = double.tryParse(entry.weightController.text.trim());
      final reps = int.tryParse(entry.repsController.text.trim());
      final sets = int.tryParse(entry.setsController.text.trim());
      if (weight == null || reps == null || sets == null) {
        continue;
      }
      final isPr = _updatePersonalRecords(
        exerciseName: exercise.name,
        weight: weight,
        reps: reps,
      );
      logs.add(
        _ExerciseLog(
          exerciseName: exercise.name,
          weight: weight,
          reps: reps,
          setsDone: sets,
          isPr: isPr,
        ),
      );
    }

    if (logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajoutez des charges pour sauvegarder.')),
      );
      return;
    }

    setState(() {
      _history.insert(
        0,
        _WorkoutHistoryEntry(
          date: now,
          routineTitle: plan.title,
          logs: logs,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Séance sauvegardée avec succès.')),
    );
  }

  bool _updatePersonalRecords({
    required String exerciseName,
    required double weight,
    required int reps,
  }) {
    final record = _personalRecords.putIfAbsent(
      exerciseName,
      () => _PersonalRecord(),
    );
    final maxWeightUpdated = record.updateMaxWeight(weight);
    final maxRepsUpdated = record.updateMaxRepsAtWeight(weight, reps);
    return maxWeightUpdated || maxRepsUpdated;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _buildExportCsv() {
    final buffer = StringBuffer('Jour,Exercice,Sets×Reps,Poids,PR\n');
    for (final entry in _history) {
      for (final log in entry.logs) {
        buffer.writeln(
          '${_formatDate(entry.date)},'
          '${log.exerciseName},'
          '${log.setsDone}x${log.reps},'
          '${log.weight},'
          '${log.isPr ? 'Oui' : 'Non'}',
        );
      }
    }
    return buffer.toString();
  }

  void _exportHistory() {
    final csv = _buildExportCsv();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export prêt. Copiez dans Sheets/Excel.')),
    );
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Export CSV'),
          content: SingleChildScrollView(
            child: Text(csv),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routine = _weeklyPlan[DateTime.now().weekday];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Programme Fixe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: routine == null
          ? _RestDayView(
              onExport: _exportHistory,
              history: _history,
              formatDate: _formatDate,
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _RoutineHeader(
                  title: routine.title,
                  focus: routine.focus,
                  timeRange: '${routine.startTime}–${routine.endTime}',
                  cardio: routine.cardio,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _saveSession(routine),
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Sauvegarder la séance'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Exercices & Charges',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final exercise in routine.exercises)
                  _ExerciseCard(
                    exercise: exercise,
                    entry: _exerciseEntries[exercise.name]!,
                    record: _personalRecords[exercise.name],
                  ),
                const SizedBox(height: 16),
                _HistorySection(
                  history: _history,
                  formatDate: _formatDate,
                  onExport: _exportHistory,
                ),
              ],
            ),
    );
  }
}

class _RoutinePlan {
  const _RoutinePlan({
    required this.title,
    required this.focus,
    required this.cardio,
    required this.startTime,
    required this.endTime,
    required this.exercises,
  });

  final String title;
  final String focus;
  final String cardio;
  final String startTime;
  final String endTime;
  final List<_RoutineExercise> exercises;
}

class _RoutineExercise {
  const _RoutineExercise({
    required this.name,
    required this.targetSets,
    required this.repsRange,
  });

  final String name;
  final int targetSets;
  final String repsRange;
}

class _ExerciseEntry {
  _ExerciseEntry({required this.exerciseName});

  final String exerciseName;
  final TextEditingController weightController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();

  void dispose() {
    weightController.dispose();
    repsController.dispose();
    setsController.dispose();
  }
}

class _PersonalRecord {
  double? maxWeight;
  final Map<double, int> maxRepsByWeight = {};

  bool updateMaxWeight(double weight) {
    if (maxWeight == null || weight > maxWeight!) {
      maxWeight = weight;
      return true;
    }
    return false;
  }

  bool updateMaxRepsAtWeight(double weight, int reps) {
    final current = maxRepsByWeight[weight];
    if (current == null || reps > current) {
      maxRepsByWeight[weight] = reps;
      return true;
    }
    return false;
  }

  int? bestRepsForWeight(double? weight) {
    if (weight == null) {
      return null;
    }
    return maxRepsByWeight[weight];
  }
}

class _ExerciseLog {
  _ExerciseLog({
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.setsDone,
    required this.isPr,
  });

  final String exerciseName;
  final double weight;
  final int reps;
  final int setsDone;
  final bool isPr;
}

class _WorkoutHistoryEntry {
  _WorkoutHistoryEntry({
    required this.date,
    required this.routineTitle,
    required this.logs,
  });

  final DateTime date;
  final String routineTitle;
  final List<_ExerciseLog> logs;
}

class _RoutineHeader extends StatelessWidget {
  const _RoutineHeader({
    required this.title,
    required this.focus,
    required this.timeRange,
    required this.cardio,
  });

  final String title;
  final String focus;
  final String timeRange;
  final String cardio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(focus, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 6),
                Text(timeRange),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.favorite, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(cardio)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.entry,
    required this.record,
  });

  final _RoutineExercise exercise;
  final _ExerciseEntry entry;
  final _PersonalRecord? record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxWeight = record?.maxWeight;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise.name, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '${exercise.targetSets} séries • ${exercise.repsRange} reps',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _InputField(
                  controller: entry.weightController,
                  label: 'Poids (kg)',
                ),
                const SizedBox(width: 12),
                _InputField(
                  controller: entry.repsController,
                  label: 'Reps',
                ),
                const SizedBox(width: 12),
                _InputField(
                  controller: entry.setsController,
                  label: 'Séries',
                ),
              ],
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: entry.weightController,
              builder: (context, value, child) {
                final bestReps = record
                    ?.bestRepsForWeight(double.tryParse(value.text.trim()));
                return Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        maxWeight == null
                            ? 'PR poids: —'
                            : 'PR poids: ${maxWeight.toStringAsFixed(1)} kg',
                      ),
                    ),
                    Chip(
                      label: Text(
                        bestReps == null
                            ? 'PR reps @ poids: —'
                            : 'PR reps @ poids: $bestReps',
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({
    required this.history,
    required this.formatDate,
    required this.onExport,
  });

  final List<_WorkoutHistoryEntry> history;
  final String Function(DateTime) formatDate;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Historique', style: theme.textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: history.isEmpty ? null : onExport,
              icon: const Icon(Icons.table_chart),
              label: const Text('Export Sheet'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (history.isEmpty)
          const Text('Aucune séance enregistrée pour le moment.')
        else
          ...history.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.routineTitle} • ${formatDate(entry.date)}',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    ...entry.logs.map(
                      (log) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '${log.exerciseName}: ${log.setsDone}x${log.reps} '
                          'à ${log.weight} kg ${log.isPr ? '• PR' : ''}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _RestDayView extends StatelessWidget {
  const _RestDayView({
    required this.onExport,
    required this.history,
    required this.formatDate,
  });

  final VoidCallback onExport;
  final List<_WorkoutHistoryEntry> history;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aujourd’hui : repos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Les séances sont prévues lundi, mercredi et vendredi à 18h30.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _HistorySection(
          history: history,
          formatDate: formatDate,
          onExport: onExport,
        ),
      ],
    );
  }
}

/// 404 Not Found screen
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100, color: Colors.red),
            SizedBox(height: 24),
            Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'The page you are looking for does not exist.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
