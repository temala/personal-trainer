import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitness_training_app/features/profile/presentation/providers/profile_providers.dart';

import 'package:fitness_training_app/shared/presentation/widgets/loading_overlay.dart';

/// Privacy settings screen
class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({super.key});

  static const routeName = '/privacy-settings';

  @override
  ConsumerState<PrivacySettingsScreen> createState() =>
      _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  bool _shareDataForImprovement = true;
  bool _allowAnalytics = true;
  bool _allowPersonalization = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  void _loadPrivacySettings() {
    final userProfile = ref.read(currentUserProfileProvider);
    userProfile.whenData((profile) {
      if (profile != null) {
        final preferences = profile.preferences ?? {};
        setState(() {
          _shareDataForImprovement =
              (preferences['shareDataForImprovement'] as bool?) ?? true;
          _allowAnalytics = (preferences['allowAnalytics'] as bool?) ?? true;
          _allowPersonalization =
              (preferences['allowPersonalization'] as bool?) ?? true;
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
        title: const Text('Privacy & Data'),
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

            // Privacy information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: Colors.green[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Your Privacy Matters',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We take your privacy seriously. All data is encrypted and stored securely. You have full control over what data is shared and how it\'s used.',
                    style: TextStyle(color: Colors.green[700], fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Data sharing settings
            _buildSettingsSection('Data Sharing', [
              _buildSwitchTile(
                title: 'Share Data for App Improvement',
                subtitle:
                    'Help us improve the app by sharing anonymous usage data',
                value: _shareDataForImprovement,
                onChanged: (value) {
                  setState(() {
                    _shareDataForImprovement = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Allow Analytics',
                subtitle: 'Enable analytics to help us understand app usage',
                value: _allowAnalytics,
                onChanged: (value) {
                  setState(() {
                    _allowAnalytics = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Allow Personalization',
                subtitle: 'Use your data to personalize your experience',
                value: _allowPersonalization,
                onChanged: (value) {
                  setState(() {
                    _allowPersonalization = value;
                  });
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Data management
            _buildSettingsSection('Data Management', [
              _buildActionTile(
                icon: Icons.download,
                title: 'Export My Data',
                subtitle: 'Download a copy of all your data',
                onTap: _exportData,
              ),
              _buildActionTile(
                icon: Icons.refresh,
                title: 'Clear Cache',
                subtitle: 'Clear locally stored temporary data',
                onTap: _clearCache,
              ),
              _buildActionTile(
                icon: Icons.delete_forever,
                title: 'Delete All Data',
                subtitle: 'Permanently delete all your data',
                onTap: _showDeleteDataDialog,
                textColor: Colors.red,
              ),
            ]),

            const SizedBox(height: 24),

            // Legal information
            _buildSettingsSection('Legal', [
              _buildActionTile(
                icon: Icons.description,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: _showPrivacyPolicy,
              ),
              _buildActionTile(
                icon: Icons.gavel,
                title: 'Terms of Service',
                subtitle: 'Read our terms of service',
                onTap: _showTermsOfService,
              ),
              _buildActionTile(
                icon: Icons.cookie,
                title: 'Cookie Policy',
                subtitle: 'Learn about our cookie usage',
                onTap: _showCookiePolicy,
              ),
            ]),

            const SizedBox(height: 24),

            // Data retention information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Retention',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your workout data is stored for as long as your account is active. You can delete your account and all associated data at any time from the Account Settings.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
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

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Theme.of(context).primaryColor),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _exportData() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Preparing your data...'),
              ],
            ),
          ),
    );

    // Simulate data export
    await Future<void>.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog

      showDialog<void>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Data Export Ready'),
              content: const Text(
                'Your data has been prepared for download. Check your email for the download link.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _clearCache() async {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cache'),
            content: const Text(
              'This will clear all locally stored temporary data. Your account data will not be affected.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  // Show loading
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) => const AlertDialog(
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Text('Clearing cache...'),
                            ],
                          ),
                        ),
                  );

                  // Simulate cache clearing
                  await Future<void>.delayed(const Duration(seconds: 2));

                  if (mounted) {
                    Navigator.of(context).pop(); // Close loading dialog

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cache cleared successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete All Data'),
            content: const Text(
              'This will permanently delete all your data including workout history, progress, and preferences. This action cannot be undone.\n\nTo delete your data, you must delete your account from Account Settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/account-settings');
                },
                child: const Text(
                  'Go to Account Settings',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Privacy Policy'),
            content: const SingleChildScrollView(
              child: Text(
                'This is a placeholder for the privacy policy. In a real app, this would contain the full privacy policy text or open a web view to display the policy.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showTermsOfService() {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Terms of Service'),
            content: const SingleChildScrollView(
              child: Text(
                'This is a placeholder for the terms of service. In a real app, this would contain the full terms text or open a web view to display the terms.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showCookiePolicy() {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cookie Policy'),
            content: const SingleChildScrollView(
              child: Text(
                'This is a placeholder for the cookie policy. In a real app, this would contain information about cookie usage.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveSettings() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final preferences = {
      'shareDataForImprovement': _shareDataForImprovement,
      'allowAnalytics': _allowAnalytics,
      'allowPersonalization': _allowPersonalization,
    };

    final controller = ref.read(profileControllerProvider);
    final success = await controller.updateUserPreferences(
      userId: userId,
      preferences: preferences,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Privacy settings saved!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
