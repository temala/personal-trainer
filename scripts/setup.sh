#!/bin/bash

# Fitness Training App Setup Script
# This script helps set up the development environment

set -e

echo "🏋️ Fitness Training App Setup Script"
echo "======================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "⚠️  Firebase CLI is not installed."
    echo "   Installing Firebase CLI..."
    npm install -g firebase-tools
fi

echo "✅ Firebase CLI is available"

# Check if FlutterFire CLI is installed
if ! command -v flutterfire &> /dev/null; then
    echo "⚠️  FlutterFire CLI is not installed."
    echo "   Installing FlutterFire CLI..."
    dart pub global activate flutterfire_cli
fi

echo "✅ FlutterFire CLI is available"

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

# Generate code
echo "🔧 Generating code..."
dart run build_runner build

# Check for environment file
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found."
    echo "   Copying .env.example to .env..."
    cp .env.example .env
    echo "   Please edit .env file with your actual API keys."
fi

# Check for Firebase configuration
if [ ! -f "lib/firebase_options.dart" ]; then
    echo "⚠️  Firebase configuration not found."
    echo "   Please run: flutterfire configure"
    echo "   This will set up Firebase for your project."
fi

# Check for Android configuration
if [ ! -f "android/app/google-services.json" ]; then
    echo "⚠️  Android Firebase configuration not found."
    echo "   Please add google-services.json to android/app/"
fi

# Check for iOS configuration
if [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo "⚠️  iOS Firebase configuration not found."
    echo "   Please add GoogleService-Info.plist to ios/Runner/"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Configure Firebase:"
echo "   - Run: flutterfire configure"
echo "   - Add google-services.json and GoogleService-Info.plist"
echo ""
echo "2. Configure API keys:"
echo "   - Edit .env file with your OpenAI API key"
echo ""
echo "3. Run the app:"
echo "   - flutter run"
echo ""
echo "4. Test authentication:"
echo "   - Register a new user"
echo "   - Verify email"
echo "   - Complete profile setup"
echo ""
echo "For detailed instructions, see README.md"