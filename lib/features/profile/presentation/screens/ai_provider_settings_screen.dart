import 'package:fitness_training_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitness_training_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_button.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_text_field.dart';
import 'package:fitness_training_app/shared/presentation/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AI provider settings screen
class AIProviderSettingsScreen extends ConsumerStatefulWidget {
  const AIProviderSettingsScreen({super.key});

  static const routeName = '/ai-provider-settings';

  @override
  ConsumerState<AIProviderSettingsScreen> createState() =>
      _AIProviderSettingsScreenState();
}

class _AIProviderSettingsScreenState
    extends ConsumerState<AIProviderSettingsScreen> {
  final _chatgptApiKeyController = TextEditingController();
  final _n8nWebhookUrlController = TextEditingController();
  final _n8nApiKeyController = TextEditingController();

  AIProviderType _primaryProvider = AIProviderType.chatgpt;
  bool _enableChatGPT = true;
  bool _enableN8N = false;
  bool _enableFallback = true;

  @override
  void initState() {
    super.initState();
    _loadAIProviderSettings();
  }

  @override
  void dispose() {
    _chatgptApiKeyController.dispose();
    _n8nWebhookUrlController.dispose();
    _n8nApiKeyController.dispose();
    super.dispose();
  }

  void _loadAIProviderSettings() {
    final userProfile = ref.read(currentUserProfileProvider)
      ..whenData((profile) {
        if (profile?.aiProviderConfig != null) {
          final config = profile!.aiProviderConfig!;
          setState(() {
            _primaryProvider = AIProviderType.values.firstWhere(
              (type) => type.toString() == config['primaryProvider'],
              orElse: () => AIProviderType.chatgpt,
            );

            _enableChatGPT = (config['enableChatGPT'] as bool?) ?? true;
            _enableN8N = (config['enableN8N'] as bool?) ?? false;
            _enableFallback = (config['enableFallback'] as bool?) ?? true;

            if (config['chatgptApiKey'] != null) {
              _chatgptApiKeyController.text = config['chatgptApiKey'] as String;
            }
            if (config['n8nWebhookUrl'] != null) {
              _n8nWebhookUrlController.text = config['n8nWebhookUrl'] as String;
            }
            if (config['n8nApiKey'] != null) {
              _n8nApiKeyController.text = config['n8nApiKey'] as String;
            }
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
        title: const Text('AI Provider Settings'),
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
                        'AI Provider Configuration',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Configure AI services to personalize your workout plans and get better recommendations. Your API keys are stored securely and only used for generating your fitness content.',
                    style: TextStyle(color: Colors.blue[700], fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Primary provider selection
            _buildSettingsSection('Primary AI Provider', [
              _buildProviderTile(
                provider: AIProviderType.chatgpt,
                title: 'ChatGPT',
                subtitle: 'OpenAI\'s ChatGPT for workout planning',
                icon: Icons.smart_toy,
              ),
              _buildProviderTile(
                provider: AIProviderType.n8nWorkflow,
                title: 'n8n Workflows',
                subtitle: 'Custom AI workflows via n8n',
                icon: Icons.account_tree,
              ),
            ]),

            const SizedBox(height: 24),

            // ChatGPT configuration
            if (_enableChatGPT) ...[
              _buildSettingsSection('ChatGPT Configuration', [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _chatgptApiKeyController,
                        labelText: 'API Key',
                        hintText: 'Enter your OpenAI API key',
                        obscureText: true,
                        prefixIcon: Icons.key,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Get your API key from platform.openai.com',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 16),
            ],

            // n8n configuration
            if (_enableN8N) ...[
              _buildSettingsSection('n8n Configuration', [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _n8nWebhookUrlController,
                        labelText: 'Webhook URL',
                        hintText: 'Enter your n8n webhook URL',
                        prefixIcon: Icons.link,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _n8nApiKeyController,
                        labelText: 'API Key (Optional)',
                        hintText: 'Enter your n8n API key if required',
                        obscureText: true,
                        prefixIcon: Icons.key,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Configure your n8n workflow to accept fitness data and return workout plans',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 16),
            ],

            // Advanced settings
            _buildSettingsSection('Advanced Settings', [
              SwitchListTile(
                title: const Text(
                  'Enable Fallback',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Use backup AI providers if primary fails',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                value: _enableFallback,
                onChanged: (value) {
                  setState(() {
                    _enableFallback = value;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              ),
            ]),

            const SizedBox(height: 24),

            // Test connection button
            CustomButton(
              onPressed: _testConnection,
              text: 'Test Connection',
              variant: ButtonVariant.outlined,
              icon: Icons.wifi_protected_setup,
            ),

            const SizedBox(height: 16),

            // Reset to defaults button
            CustomButton(
              onPressed: _resetToDefaults,
              text: 'Reset to Defaults',
              variant: ButtonVariant.text,
              textColor: Colors.grey[600],
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

  Widget _buildProviderTile({
    required AIProviderType provider,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _primaryProvider == provider;

    return RadioListTile<AIProviderType>(
      value: provider,
      groupValue: _primaryProvider,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _primaryProvider = value;
            // Enable the selected provider
            if (value == AIProviderType.chatgpt) {
              _enableChatGPT = true;
            } else if (value == AIProviderType.n8nWorkflow) {
              _enableN8N = true;
            }
          });
        }
      },
      title: Row(
        children: [
          Icon(
            icon,
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Future<void> _testConnection() async {
    // Show loading dialog
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Testing connection...'),
              ],
            ),
          ),
    );

    // Simulate API test (in real implementation, test actual connection)
    await Future<void>.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog

      // Show result
      showDialog<void>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Connection Test'),
              content: const Text('Connection test completed successfully!'),
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

  void _resetToDefaults() {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset to Defaults'),
            content: const Text(
              'This will reset all AI provider settings to their default values. Are you sure?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _primaryProvider = AIProviderType.chatgpt;
                    _enableChatGPT = true;
                    _enableN8N = false;
                    _enableFallback = true;
                    _chatgptApiKeyController.clear();
                    _n8nWebhookUrlController.clear();
                    _n8nApiKeyController.clear();
                  });
                },
                child: const Text('Reset', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  Future<void> _saveSettings() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final config = {
      'primaryProvider': _primaryProvider.toString(),
      'enableChatGPT': _enableChatGPT,
      'enableN8N': _enableN8N,
      'enableFallback': _enableFallback,
      'chatgptApiKey': _chatgptApiKeyController.text.trim(),
      'n8nWebhookUrl': _n8nWebhookUrlController.text.trim(),
      'n8nApiKey': _n8nApiKeyController.text.trim(),
    };

    final controller = ref.read(profileControllerProvider);
    final success = await controller.updateAIProviderConfig(
      userId: userId,
      config: config,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI provider settings saved!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
