import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_training_app/firebase_options.dart';
import 'package:fitness_training_app/core/utils/logger.dart';

/// Firebase configuration and initialization
class FirebaseConfig {
  static bool _initialized = false;

  /// Initialize Firebase services
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Check if Firebase is already initialized
      try {
        Firebase.app();
        AppLogger.info('Firebase already initialized');
        _initialized = true;
        return;
      } catch (e) {
        // Firebase not initialized, proceed with initialization
        AppLogger.info('Initializing Firebase...');
      }

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      AppLogger.info('Firebase initialized successfully');

      // Initialize Crashlytics (optional, don't fail if it doesn't work)
      try {
        await _initializeCrashlytics();
      } catch (e, stackTrace) {
        AppLogger.error(
          'Failed to initialize Crashlytics (non-critical)',
          e,
          stackTrace,
        );
      }

      // Initialize Firebase Messaging (optional, don't fail if it doesn't work)
      try {
        await _initializeMessaging();
      } catch (e, stackTrace) {
        AppLogger.error(
          'Failed to initialize Firebase Messaging (non-critical)',
          e,
          stackTrace,
        );
      }

      _initialized = true;
      AppLogger.info('Firebase core services initialized');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Firebase', e, stackTrace);
      rethrow;
    }
  }

  /// Initialize Firebase Crashlytics
  static Future<void> _initializeCrashlytics() async {
    try {
      // Enable Crashlytics collection
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      // Set up automatic crash reporting
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Handle async errors
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      AppLogger.info('Crashlytics initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Crashlytics', e, stackTrace);
    }
  }

  /// Initialize Firebase Messaging
  static Future<void> _initializeMessaging() async {
    try {
      final messaging = FirebaseMessaging.instance;

      // Request permission for notifications
      final settings = await messaging.requestPermission(announcement: false);

      AppLogger.info(
        'Notification permission status: ${settings.authorizationStatus}',
      );

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AppLogger.info('Received foreground message: ${message.messageId}');
        // Handle foreground notification display
      });

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        AppLogger.info('Notification tapped: ${message.messageId}');
        // Handle notification tap navigation
      });

      AppLogger.info('Firebase Messaging initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Firebase Messaging', e, stackTrace);
    }
  }

  /// Get FCM token for this device
  static Future<String?> getFCMToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      AppLogger.info('FCM Token obtained');
      return token;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get FCM token', e, stackTrace);
      return null;
    }
  }

  /// Subscribe to FCM topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      AppLogger.info('Subscribed to topic: $topic');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to subscribe to topic: $topic', e, stackTrace);
    }
  }

  /// Unsubscribe from FCM topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      AppLogger.info('Unsubscribed from topic: $topic');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to unsubscribe from topic: $topic',
        e,
        stackTrace,
      );
    }
  }
}

/// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AppLogger.info('Handling background message: ${message.messageId}');
}
