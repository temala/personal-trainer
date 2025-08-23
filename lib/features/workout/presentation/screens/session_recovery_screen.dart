import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/shared/data/services/workout_session_persistence_service.dart';
import 'package:fitness_training_app/shared/presentation/providers/workout_session_providers.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_button.dart';
import 'package:fitness_training_app/shared/presentation/widgets/loading_overlay.dart';

/// Screen for recovering abandoned workout sessions
class SessionRecoveryScreen extends ConsumerStatefulWidget {
  const SessionRecoveryScreen({super.key});

  @override
  ConsumerState<SessionRecoveryScreen> createState() =>
      _SessionRecoveryScreenState();
}

class _SessionRecoveryScreenState extends ConsumerState<SessionRecoveryScreen> {
  bool _isLoading = false;
  List<SessionRecoveryData> _recoverySessions = [];

  @override
  void initState() {
    super.initState();
    _loadRecoverySessions();
  }

  Future<void> _loadRecoverySessions() async {
    setState(() => _isLoading = true);

    try {
      // This would need to be implemented in the providers
      // For now, we'll create a mock implementation
      _recoverySessions = [];

      // TODO: Implement actual recovery session loading
      // final sessions = await ref.read(sessionRecoveryProvider.future);
      // setState(() => _recoverySessions = sessions);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading recovery sessions: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recover Workout'),
        backgroundColor: Colors.orange.shade100,
        foregroundColor: Colors.orange.shade800,
      ),
      body: LoadingOverlay(isLoading: _isLoading, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    if (_recoverySessions.isEmpty) {
      return _buildNoSessionsContent();
    }

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            border: Border(bottom: BorderSide(color: Colors.orange.shade200)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.restore, color: Colors.orange.shade700, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Incomplete Workouts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'You have ${_recoverySessions.length} workout${_recoverySessions.length == 1 ? '' : 's'} that were interrupted. You can resume or discard them.',
                style: TextStyle(fontSize: 14, color: Colors.orange.shade600),
              ),
            ],
          ),
        ),

        // Recovery sessions list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _recoverySessions.length,
            itemBuilder: (context, index) {
              final session = _recoverySessions[index];
              return _buildRecoverySessionCard(session);
            },
          ),
        ),

        // Bottom actions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Discard All',
                  onPressed: _handleDiscardAll,
                  color: Colors.red,
                  variant: ButtonVariant.outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Continue Later',
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoSessionsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Incomplete Workouts',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'All your workout sessions are up to date!',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Start New Workout',
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildRecoverySessionCard(SessionRecoveryData session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        session.isRecentlyActive
                            ? Colors.orange.shade100
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.isRecentlyActive ? 'RECENT' : 'OLDER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color:
                          session.isRecentlyActive
                              ? Colors.orange.shade700
                              : Colors.grey.shade600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  session.timeSinceLastActive,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Session info
            Text(
              'Workout Session',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Progress info
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Exercise ${session.currentExerciseIndex + 1}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 16),
                if (session.wasRecovering) ...[
                  Icon(Icons.timer, size: 16, color: Colors.blue.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Was in recovery',
                    style: TextStyle(fontSize: 14, color: Colors.blue.shade600),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Discard',
                    onPressed: () => _handleDiscardSession(session),
                    color: Colors.red,
                    variant: ButtonVariant.outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    text: 'Resume Workout',
                    onPressed: () => _handleResumeSession(session),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleResumeSession(SessionRecoveryData session) async {
    setState(() => _isLoading = true);

    try {
      final actions = ref.read(workoutSessionActionsProvider);

      // Load the session and resume it
      await actions.loadSession(session.sessionId);

      if (mounted) {
        // Navigate to workout session screen
        Navigator.of(context).pushReplacementNamed('/workout-session');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error resuming session: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDiscardSession(SessionRecoveryData session) async {
    final confirmed = await _showDiscardConfirmation(single: true);
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement session discard logic
      // await ref.read(sessionRecoveryProvider.notifier).discardSession(session.sessionId);

      // Remove from local list
      setState(() {
        _recoverySessions.removeWhere((s) => s.sessionId == session.sessionId);
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Session discarded')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error discarding session: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDiscardAll() async {
    final confirmed = await _showDiscardConfirmation(single: false);
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement discard all logic
      // await ref.read(sessionRecoveryProvider.notifier).discardAllSessions();

      setState(() {
        _recoverySessions.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('All sessions discarded')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error discarding sessions: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _showDiscardConfirmation({required bool single}) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(single ? 'Discard Session' : 'Discard All Sessions'),
            content: Text(
              single
                  ? 'Are you sure you want to discard this workout session? This action cannot be undone.'
                  : 'Are you sure you want to discard all incomplete workout sessions? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Discard'),
              ),
            ],
          ),
    );

    return result ?? false;
  }
}
