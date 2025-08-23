# Fitness Training App

AI-powered gamified fitness training app with personalized cartoon avatars.

## Features

- 🤖 AI-powered workout plan generation (ChatGPT, N8N workflows)
- 🎮 Gamified fitness experience with cartoon avatars
- 📱 Cross-platform Flutter application
- 🔄 Multiple AI provider support with fallback
- 📊 Progress tracking and analysis

## Configuration

### AI Provider Setup

This app supports multiple AI providers for generating workout plans and fitness content.

#### 1. ChatGPT API Key Configuration

**Option A: Environment Variables (Recommended for Development)**

1. Create a `.env` file in the project root:
```bash
# .env
CHATGPT_API_KEY=your_chatgpt_api_key_here
N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/workout-plan
```

2. Add `.env` to your `.gitignore` file to keep it secure.

**Option B: Flutter Environment Variables**

1. Create `lib/core/config/env_config.dart`:
```dart
class EnvConfig {
  static const String chatgptApiKey = String.fromEnvironment(
    'CHATGPT_API_KEY',
    defaultValue: '',
  );
  
  static const String n8nWebhookUrl = String.fromEnvironment(
    'N8N_WEBHOOK_URL', 
    defaultValue: '',
  );
}
```

2. Run your app with environment variables:
```bash
flutter run --dart-define=CHATGPT_API_KEY=your_api_key_here
```

**Option C: Secure Storage (Recommended for Production)**

The app can store API keys securely using `flutter_secure_storage`:

```dart
// Store API key securely
await secureStorage.write(key: 'chatgpt_api_key', value: 'your_api_key');

// Retrieve API key
final apiKey = await secureStorage.read(key: 'chatgpt_api_key');
```

#### 2. Getting Your ChatGPT API Key

1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Sign up or log in to your account
3. Navigate to API Keys section
4. Create a new API key
5. Copy the key (it will only be shown once)

#### 3. Usage Example

```dart
import 'package:fitness_training_app/shared/data/repositories/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_entities.dart';

// Initialize AI configuration
final config = AIConfiguration.defaultConfig(
  chatgptApiKey: 'your-api-key-here',
  n8nWebhookUrl: 'https://your-n8n-instance.com/webhook', // Optional
);

// Create AI provider manager
final aiManager = AIProviderManager(config);

// Generate workout plan
final response = await aiManager.generateWorkoutPlan(
  userId: 'user123',
  userProfile: {
    'name': 'John Doe',
    'age': 30,
    'fitnessLevel': 'beginner',
  },
  availableExercises: [
    {'id': 'pushups', 'name': 'Push-ups'},
    {'id': 'squats', 'name': 'Squats'},
  ],
);
```

### Security Best Practices

⚠️ **Never commit API keys to version control!**

1. **Always use `.gitignore`** for sensitive files
2. **Use environment variables** for development
3. **Use secure storage** for production apps
4. **Rotate API keys** regularly
5. **Monitor API usage** to detect unauthorized access

## Getting Started

### Prerequisites

- Flutter SDK (>=3.7.2)
- Dart SDK
- Android Studio / VS Code
- OpenAI API key (for AI features)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd fitness_training_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code:
```bash
dart run build_runner build
```

4. Configure your API keys (see Configuration section above)

5. Run the app:
```bash
flutter run
```

### Development

- **Code Generation**: Run `dart run build_runner build` after modifying Freezed models
- **Testing**: Run `flutter test` for unit tests
- **Analysis**: Run `flutter analyze` to check code quality

## Architecture

The app follows Clean Architecture principles:

- **Domain Layer**: Entities, repositories, and use cases
- **Data Layer**: Data sources, repositories implementation
- **Presentation Layer**: UI components and state management

### AI Provider System

- **Multiple Providers**: ChatGPT, N8N workflows, extensible for more
- **Fallback Support**: Automatic failover between providers
- **Configuration Management**: Flexible provider configuration
- **Error Handling**: Comprehensive error handling and logging
