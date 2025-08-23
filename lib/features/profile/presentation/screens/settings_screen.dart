import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitness_training_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/notification_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/ai_provider_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/privacy_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/account_settings_screen.dart';
import 'package:fitness_training_app/shared/presentation/widgets/loading_overlay.dart';

/// Main settings screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userProfile = ref.watch(currentUserProfileProvider);
    final isLoading = ref.watch(profileLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User info section
            if (currentUser != null) ...[
              _buildUserInfoSection(context, currentUser, userProfile),
              const SizedBox(height: 24),
            ],

            // Settings sections
            _buildSettingsSection(context, 'Notifications', [
              _buildSettingsTile(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notification Preferences',
                subtitle: 'Manage workout reminders and updates',
                onTap:
                    () => Navigator.of(
                      context,
                    ).pushNamed(NotificationSettingsScreen.routeName),
              ),
            ]),

            const SizedBox(height: 16),

            _buildSettingsSection(context, 'AI & Personalization', [
              _buildSettingsTile(
                context,
                icon: Icons.smart_toy_outlined,
                title: 'AI Provider Settings',
                subtitle: 'Configure AI services and preferences',
                onTap:
                    () => Navigator.of(
                      context,
                    ).pushNamed(AIProviderSettingsScreen.routeName),
              ),
            ]),

            const SizedBox(height: 16),

            _buildSettingsSection(context, 'Privacy & Data', [
              _buildSettingsTile(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Settings',
                subtitle: 'Data export and privacy controls',
                onTap:
                    () => Navigator.of(
                      context,
                    ).pushNamed(PrivacySettingsScreen.routeName),
              ),
            ]),

            const SizedBox(height: 16),

            _buildSettingsSection(context, 'Account', [
              _buildSettingsTile(
                context,
                icon: Icons.person_outline,
                title: 'Account Settings',
                subtitle: 'Manage your account and profile',
                onTap:
                    () => Navigator.of(
                      context,
                    ).pushNamed(AccountSettingsScreen.routeName),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                onTap: () => _showSignOutDialog(context, ref),
                textColor: Colors.red,
              ),
            ]),

            const SizedBox(height: 24),

            // App info
            _buildAppInfoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(
    BuildContext context,
    dynamic user,
    AsyncValue<UserProfile?> userProfile,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              (user.displayName as String?)?.substring(0, 1).toUpperCase() ??
                  (user.email as String?)?.substring(0, 1).toUpperCase() ??
                  'U',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (user.displayName as String?) ?? 'User',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  (user.email as String?) ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                userProfile.when(
                  data: (profile) {
                    if (profile?.isActivePremium == true) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Free',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
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

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
    Widget? trailing,
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
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Fitness Training App',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'AI-powered gamified fitness training',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final controller = ref.read(authControllerProvider);
                  final success = await controller.signOut();

                  if (success && context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/sign-in', (route) => false);
                  }
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
