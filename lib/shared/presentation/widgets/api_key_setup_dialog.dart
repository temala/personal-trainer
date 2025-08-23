import 'package:flutter/material.dart';

import 'package:fitness_training_app/core/config/ai_config_service.dart';
import 'package:fitness_training_app/core/services/ai_service_initializer.dart';

/// Dialog for setting up API keys
class ApiKeySetupDialog extends StatefulWidget {
  const ApiKeySetupDialog({super.key});

  @override
  State<ApiKeySetupDialog> createState() => _ApiKeySetupDialogState();
}

class _ApiKeySetupDialogState extends State<ApiKeySetupDialog> {
  final _chatgptController = TextEditingController();
  final _n8nController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureApiKey = true;

  @override
  void dispose() {
    _chatgptController.dispose();
    _n8nController.dispose();
    super.dispose();
  }

  Future<void> _saveConfiguration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Store API keys securely
      if (_chatgptController.text.isNotEmpty) {
        await AIConfigService.storeChatGptApiKey(
          _chatgptController.text.trim(),
        );
      }

      if (_n8nController.text.isNotEmpty) {
        await AIConfigService.storeN8nWebhookUrl(_n8nController.text.trim());
      }

      // Reinitialize AI services with new configuration
      await AIServiceInitializer.initialize();

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI configuration saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving configuration: $e'),
            backgroundColor: Colors.red,
          ),
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
    return AlertDialog(
      title: const Text('AI Configuration'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Configure your AI providers to enable smart workout features.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _chatgptController,
              obscureText: _obscureApiKey,
              decoration: InputDecoration(
                labelText: 'ChatGPT API Key *',
                hintText: 'sk-...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureApiKey ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed:
                      () => setState(() => _obscureApiKey = !_obscureApiKey),
                ),
                helperText: 'Get your key from platform.openai.com',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ChatGPT API key is required';
                }
                if (!value.startsWith('sk-')) {
                  return 'Invalid API key format';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _n8nController,
              decoration: const InputDecoration(
                labelText: 'N8N Webhook URL (Optional)',
                hintText: 'https://your-n8n-instance.com/webhook/...',
                border: OutlineInputBorder(),
                helperText: 'For advanced AI workflows',
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!Uri.tryParse(value)!.hasAbsolutePath == true) {
                    return 'Invalid URL format';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveConfiguration,
          child:
              _isLoading
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Save'),
        ),
      ],
    );
  }
}

/// Helper function to show the API key setup dialog
Future<bool?> showApiKeySetupDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const ApiKeySetupDialog(),
  );
}
