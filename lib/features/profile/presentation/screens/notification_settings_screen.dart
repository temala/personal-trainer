import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitness_training_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:fitness_training_app/shared/presentation/widgets/loading_overlay.dart';

/// Notification settings screen
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  static const routeName = '/notification-settings';

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  bool _workoutReminders = true;
  bool _progressUpdates = true;
  bool _motivationalMessages = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 0);
  int _reminderFrequency = 1; // days

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  void _loadNotificationSettings() {
    final userProfile = ref.read(currentUserProfileProvider);
    userProfile.whenData((profile) {
      if (profile != null) {
        final preferences = profile.preferences;
        setState(() {
          _workoutReminders =
              (preferences['workoutReminders'] as bool?) ?? true;
          _progressUpdates = (preferences['progressUpdates'] as bool?) ?? true;
          _motivationalMessages =
              (preferences['motivationalMessages'] as bool?) ?? true;
          _emailNotifications =
              (preferences['emailNotifications'] as bool?) ?? true;
          _pushNotifications =
              (preferences['pushNotifications'] as bool?) ?? true;

          if (preferences['reminderTime'] != null) {
            final timeString = preferences['reminderTime'] as String;
            final parts = timeString.split(':');
            _reminderTime = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }

          _reminderFrequency = (preferences['reminderFrequency'] as int?) ?? 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileLoadingProvider);
    final error = ref.watch(profileErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: _saveSettings, child: const Text('Save')),
        ],
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Error message
            if (error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red[700], fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Notification types
            _buildSettingsSection('Notification Types', [
              _buildSwitchTile(
                title: 'Workout Reminders',
                subtitle: 'Get reminded when it\'s time to work out',
                value: _workoutReminders,
                onChanged: (value) {
                  setState(() {
                    _workoutReminders = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Progress Updates',
                subtitle: 'Receive updates about your fitness progress',
                value: _progressUpdates,
                onChanged: (value) {
                  setState(() {
                    _progressUpdates = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Motivational Messages',
                subtitle: 'Get AI-powered motivational messages',
                value: _motivationalMessages,
                onChanged: (value) {
                  setState(() {
                    _motivationalMessages = value;
                  });
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Delivery methods
            _buildSettingsSection('Delivery Methods', [
              _buildSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Timing settings
            _buildSettingsSection('Timing Settings', [
              _buildTimeTile(
                title: 'Reminder Time',
                subtitle: 'When to send workout reminders',
                time: _reminderTime,
                onTap: _selectReminderTime,
              ),
              _buildFrequencyTile(
                title: 'Reminder Frequency',
                subtitle: 'How often to send reminders',
                frequency: _reminderFrequency,
                onChanged: (value) {
                  setState(() {
                    _reminderFrequency = value;
                  });
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Information section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'About Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our AI analyzes your workout patterns and preferences to send personalized notifications at the best times for you. You can adjust these settings anytime.',
                    style: TextStyle(color: Colors.blue[700], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildTimeTile({
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time.format(context),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildFrequencyTile({
    required String title,
    required String subtitle,
    required int frequency,
    required ValueChanged<int> onChanged,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing: DropdownButton<int>(
        value: frequency,
        items: [
          const DropdownMenuItem(value: 1, child: Text('Daily')),
          const DropdownMenuItem(value: 2, child: Text('Every 2 days')),
          const DropdownMenuItem(value: 3, child: Text('Every 3 days')),
          const DropdownMenuItem(value: 7, child: Text('Weekly')),
        ],
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
        underline: const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );

    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<void> _saveSettings() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final preferences = {
      'workoutReminders': _workoutReminders,
      'progressUpdates': _progressUpdates,
      'motivationalMessages': _motivationalMessages,
      'emailNotifications': _emailNotifications,
      'pushNotifications': _pushNotifications,
      'reminderTime': '${_reminderTime.hour}:${_reminderTime.minute}',
      'reminderFrequency': _reminderFrequency,
    };

    final controller = ref.read(profileControllerProvider);
    final success = await controller.updateUserPreferences(
      userId: userId,
      preferences: preferences,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings saved!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
