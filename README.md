# Fitness Training App

AI-powered gamified fitness training app with personalized cartoon avatars.

## Features

- 🤖 AI-powered workout plan generation (ChatGPT, N8N workflows)
- 🎮 Gamified fitness experience with cartoon avatars
- 📱 Cross-platform Flutter application
- 🔄 Multiple AI provider support with fallback
- 📊 Progress tracking and analysis
- 🔐 Firebase Authentication with email verification
- 👤 User profile management and preferences
- 🔔 Push notifications and reminders
- 📱 Offline support with data synchronization
- 🎯 Personalized workout recommendations

## Prerequisites

Before setting up the app, ensure you have:

- Flutter SDK (>=3.7.2)
- Dart SDK
- Android Studio / VS Code
- Firebase project with Authentication and Firestore enabled
- OpenAI API key (for AI features)
- Node.js (if using n8n workflows)

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `fitness-training-app` (or your preferred name)
4. Enable Google Analytics (optional but recommended)
5. Choose or create a Google Analytics account
6. Click "Create project"

### 2. Enable Authentication

1. In Firebase Console, go to **Authentication** → **Get started**
2. Go to **Sign-in method** tab
3. Enable **Email/Password** provider:
   - Click on "Email/Password"
   - Enable the first toggle (Email/Password)
   - Enable "Email link (passwordless sign-in)" if desired
   - Click "Save"

### 3. Configure Firestore Database

1. Go to **Firestore Database** → **Create database**
2. Choose **Start in test mode** (for development)
3. Select a location (choose closest to your users)
4. Click "Done"

#### Firestore Security Rules (Development)

Replace the default rules with these for development:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can read/write their own workouts
    match /workouts/{workoutId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Users can read/write their own workout sessions
    match /workout_sessions/{sessionId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Users can read exercises (public data)
    match /exercises/{exerciseId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

#### Firestore Indexes

Create these composite indexes in Firestore:

1. Go to **Firestore Database** → **Indexes** → **Composite**
2. Add these indexes:

```
Collection: workouts
Fields: userId (Ascending), createdAt (Descending)

Collection: workout_sessions  
Fields: userId (Ascending), completedAt (Descending)

Collection: exercises
Fields: category (Ascending), difficulty (Ascending)
```

### 4. Add Firebase to Flutter App

#### For Android:

1. In Firebase Console, click **Add app** → **Android**
2. Enter Android package name: `com.example.fitness_training_app`
3. Enter app nickname: `Fitness Training App`
4. Download `google-services.json`
5. Place it in `android/app/` directory

#### For iOS:

1. In Firebase Console, click **Add app** → **iOS**
2. Enter iOS bundle ID: `com.example.fitnessTrainingApp`
3. Enter app nickname: `Fitness Training App`
4. Download `GoogleService-Info.plist`
5. Place it in `ios/Runner/` directory

### 5. Configure Firebase Options

Generate Firebase configuration:

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter project
flutterfire configure
```

This will create `lib/firebase_options.dart` with your project configuration.

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

### Installation

1. **Clone the repository:**
```bash
git clone <repository-url>
cd fitness_training_app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate code:**
```bash
dart run build_runner build
```

4. **Configure Firebase** (see Firebase Setup section above)

5. **Configure API keys** (see Configuration section above)

6. **Run the app:**
```bash
flutter run
```

## Testing the Authentication System

### 1. Test User Registration

1. Launch the app
2. You should see the Sign In screen
3. Tap "Create Account" to go to registration
4. Fill in the form:
   - **Name**: Test User
   - **Email**: test@example.com
   - **Password**: TestPass123
   - **Confirm Password**: TestPass123
5. Tap "Create Account"
6. You should be redirected to Email Verification screen
7. Check your email for verification link
8. Click the verification link in your email
9. Return to the app and tap "I've Verified My Email"

### 2. Test Profile Setup

After email verification:

1. You should be redirected to Profile Setup screen
2. **Step 1 - Basic Info:**
   - Name should be pre-filled
   - Enter Age: 25
3. **Step 2 - Physical Info:**
   - Height: 175 (cm)
   - Current Weight: 70 (kg)
   - Target Weight: 65 (kg)
4. **Step 3 - Goals:**
   - Select a fitness goal (e.g., "Lose Weight")
   - Select activity level (e.g., "Moderately Active")
5. **Step 4 - Preferences:**
   - Select exercise types you enjoy
   - Tap "Complete Setup"

### 3. Test Settings and Preferences

1. Navigate to Settings (usually in app drawer or profile)
2. **Test Notification Settings:**
   - Go to "Notification Preferences"
   - Toggle different notification types
   - Change reminder time
   - Tap "Save"
3. **Test AI Provider Settings:**
   - Go to "AI Provider Settings"
   - Enter your OpenAI API key
   - Select ChatGPT as primary provider
   - Tap "Test Connection"
   - Tap "Save"
4. **Test Privacy Settings:**
   - Go to "Privacy Settings"
   - Toggle data sharing preferences
   - Try "Export My Data" (will simulate export)
   - Tap "Save"

### 4. Test Account Management

1. Go to "Account Settings"
2. **Test Profile Updates:**
   - Change display name
   - Tap "Update Name"
3. **Test Password Change:**
   - Enter current password
   - Enter new password
   - Confirm new password
   - Tap "Change Password"
4. **Test Email Update:**
   - Enter new email
   - Tap "Update Email"
   - Check email for verification

### 5. Verify Firebase Data

Check your Firebase Console to verify data is being saved:

1. Go to **Firestore Database**
2. You should see collections:
   - `users` - Contains user profiles
   - Check that your user document exists with correct data

3. Go to **Authentication**
   - You should see your test user listed
   - Verify email verification status

## Troubleshooting

### Common Issues

#### Firebase Configuration Issues

**Error: "No Firebase App '[DEFAULT]' has been created"**
- Ensure `firebase_options.dart` exists and is properly configured
- Run `flutterfire configure` again
- Check that `Firebase.initializeApp()` is called in `main.dart`

**Error: "FirebaseOptions cannot be null"**
- Verify `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) are in correct locations
- Clean and rebuild: `flutter clean && flutter pub get && flutter run`

#### Authentication Issues

**Email verification not working:**
- Check spam folder
- Verify Firebase Authentication is enabled
- Check Firebase Console → Authentication → Templates for email templates

**Sign-in fails:**
- Check Firebase Console → Authentication → Users to see if user was created
- Verify Firestore security rules allow user data access
- Check app logs for detailed error messages

#### API Key Issues

**ChatGPT API errors:**
- Verify API key is correct and has sufficient credits
- Check OpenAI API status
- Ensure API key has proper permissions

### Debug Mode

Enable debug logging by setting:

```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable debug logging
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  }
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}
```

### Testing with Different Environments

Create different Firebase projects for development and production:

1. **Development**: `fitness-training-app-dev`
2. **Production**: `fitness-training-app-prod`

Use different configuration files:
- `lib/firebase_options_dev.dart`
- `lib/firebase_options_prod.dart`

## Production Deployment

### Before Going Live

1. **Update Firestore Security Rules** to production-ready rules
2. **Enable App Check** for additional security
3. **Set up Firebase Analytics** for user tracking
4. **Configure Firebase Crashlytics** for error reporting
5. **Set up proper backup** for Firestore data
6. **Review and update privacy policy** and terms of service
7. **Test thoroughly** on different devices and network conditions

### Security Checklist

- [ ] API keys are not hardcoded in source code
- [ ] Firestore security rules are restrictive
- [ ] Firebase App Check is enabled
- [ ] User input is properly validated
- [ ] Sensitive data is encrypted
- [ ] Error messages don't expose sensitive information

## Quick Start Testing Guide

### 1. Complete Setup Checklist

Before testing, ensure you have completed:

- [ ] Firebase project created and configured
- [ ] `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) added
- [ ] `firebase_options.dart` generated with `flutterfire configure`
- [ ] Firestore Database created with security rules
- [ ] Authentication enabled with Email/Password provider
- [ ] Dependencies installed with `flutter pub get`
- [ ] Code generated with `dart run build_runner build`

### 2. Test Authentication Flow

**Step 1: Launch the App**
```bash
flutter run
```

**Step 2: Test Registration**
1. App should open to Sign In screen
2. Tap "Create Account"
3. Fill registration form:
   - Name: "Test User"
   - Email: "test@yourdomain.com" (use a real email you can access)
   - Password: "TestPass123"
   - Confirm Password: "TestPass123"
4. Tap "Create Account"
5. Should redirect to Email Verification screen

**Step 3: Test Email Verification**
1. Check your email for verification link
2. Click the verification link
3. Return to app and tap "I've Verified My Email"
4. Should redirect to Profile Setup screen

**Step 4: Test Profile Setup**
1. **Basic Info Step:**
   - Name should be pre-filled
   - Enter Age: 25
   - Tap "Next"

2. **Physical Info Step:**
   - Height: 175 cm
   - Current Weight: 70 kg
   - Target Weight: 65 kg
   - Tap "Next"

3. **Goals Step:**
   - Select "Lose Weight"
   - Select "Moderately Active"
   - Tap "Next"

4. **Preferences Step:**
   - Select 2-3 exercise types (e.g., Cardio, Strength Training)
   - Tap "Complete Setup"

5. Should redirect to Home screen with success message

### 3. Test Settings and Configuration

**Step 1: Access Settings**
1. From Home screen, tap Settings icon (gear icon in app bar)
2. Should see Settings screen with user info at top

**Step 2: Test Notification Settings**
1. Tap "Notification Preferences"
2. Toggle different notification types
3. Change reminder time using time picker
4. Change reminder frequency
5. Tap "Save"
6. Should see success message

**Step 3: Test AI Provider Settings**
1. Tap "AI Provider Settings"
2. Enter your OpenAI API key in ChatGPT configuration
3. Select ChatGPT as primary provider
4. Tap "Test Connection" (should show success dialog)
5. Tap "Save"
6. Should see success message

**Step 4: Test Privacy Settings**
1. Tap "Privacy Settings"
2. Toggle data sharing preferences
3. Tap "Export My Data" (should show export dialog)
4. Tap "Clear Cache" (should show confirmation and success)
5. Tap "Save"

**Step 5: Test Account Settings**
1. Tap "Account Settings"
2. Change display name and tap "Update Name"
3. Test password change:
   - Enter current password
   - Enter new password
   - Confirm new password
   - Tap "Change Password"
4. Should see success messages

### 4. Test Sign Out and Sign In

**Step 1: Sign Out**
1. In Settings, tap "Sign Out"
2. Confirm in dialog
3. Should return to Sign In screen

**Step 2: Sign In**
1. Enter your email and password
2. Tap "Sign In"
3. Should go directly to Home screen (skipping profile setup)

### 5. Verify Firebase Data

**Check Authentication:**
1. Go to Firebase Console → Authentication
2. Should see your test user listed
3. Verify email verification status

**Check Firestore:**
1. Go to Firebase Console → Firestore Database
2. Should see `users` collection with your user document
3. Verify user profile data is saved correctly

### 6. Test Error Scenarios

**Test Invalid Registration:**
1. Try registering with invalid email format
2. Try weak password
3. Try mismatched password confirmation
4. Should see appropriate error messages

**Test Invalid Sign In:**
1. Try signing in with wrong password
2. Try signing in with non-existent email
3. Should see appropriate error messages

**Test Network Issues:**
1. Turn off internet connection
2. Try to sign in or register
3. Should see network error messages

### 7. Expected Results

After successful testing, you should have:

✅ **Working Authentication System:**
- User registration with email verification
- Sign in/sign out functionality
- Password reset capability

✅ **Complete Profile Management:**
- Multi-step profile setup
- User preferences and settings
- Account management features

✅ **Firebase Integration:**
- User data stored in Firestore
- Authentication state managed by Firebase Auth
- Real-time data synchronization

✅ **Error Handling:**
- Proper error messages for all scenarios
- Loading states during operations
- Graceful handling of network issues

### 8. Next Steps

Once authentication is working:

1. **Add Workout Features:** Implement workout plan generation using AI
2. **Add Progress Tracking:** Build workout session tracking
3. **Add Social Features:** User achievements and sharing
4. **Add Premium Features:** Subscription management
5. **Add Push Notifications:** Firebase Cloud Messaging integration

### Common Issues and Solutions

**Issue: "No Firebase App has been created"**
- Solution: Ensure `firebase_options.dart` exists and `flutterfire configure` was run

**Issue: "Permission denied" in Firestore**
- Solution: Check Firestore security rules allow authenticated users to read/write their data

**Issue: Email verification not received**
- Solution: Check spam folder, verify SMTP settings in Firebase Console

**Issue: API key errors**
- Solution: Verify OpenAI API key is valid and has sufficient credits

**Issue: Build errors**
- Solution: Run `flutter clean && flutter pub get && dart run build_runner build`

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
