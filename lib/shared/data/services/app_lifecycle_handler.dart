import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/workout_session_persistence_service.dart';

/// Handles app lifecycle events for workout session persistence
class AppLifecycleHandler with WidgetsBindingObserver {
  final PersistentWorkoutSessionManager _sessionManager;
  final WorkoutSessionPersistenceService _persistenceService;

  AppLifecycleHandler({
    required PersistentWorkoutSessionManager sessionManager,
    required WorkoutSessionPersistenceService persistenceService,
  }) : _sessionManager = sessionManager,
       _persistenceService = persistenceService;

  /// Initialize the lifecycle handler
  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    AppLogger.info('App lifecycle handler initialized');
  }

  /// Dispose the lifecycle handler
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppLogger.info('App lifecycle handler disposed');
  }

  @override
  Future<bool> didPopRoute() async {
    // Handle back button press
    _handleAppPaused();
    return false;
  }

  @override
  void didChangeMetrics() {
    // Handle screen rotation or keyboard appearance
    _saveCurrentSessionState();
  }

  @override
  void didHaveMemoryPressure() {
    AppLogger.warning('Memory pressure detected, saving session state');
    _saveCurrentSessionState();
  }

  // Required abstract method implementations
  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeLocales(List<Locale>? locales) {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  Future<bool> didPushRoute(String route) async => false;

  @override
  Future<bool> didPushRouteInformation(
    RouteInformation routeInformation,
  ) async => false;

  // Note: didRequestAppExit method is not implemented due to Flutter version compatibility issues

  @override
  void didChangeViewFocus(covariant Object event) {
    // Handle view focus changes
    AppLogger.info('View focus changed: $event');
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) => false;

  @override
  bool handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) => false;

  @override
  bool handleCommitBackGesture() => false;

  @override
  bool handleCancelBackGesture() => false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLogger.info('App lifecycle state changed: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        _handleAppResumed();
      case AppLifecycleState.paused:
        _handleAppPaused();
      case AppLifecycleState.inactive:
        _handleAppInactive();
      case AppLifecycleState.detached:
        _handleAppDetached();
      case AppLifecycleState.hidden:
        _handleAppHidden();
    }
  }

  void _handleAppResumed() {
    AppLogger.info('App resumed');

    // Save lifecycle state
    _sessionManager.handleAppLifecycleChange(AppLifecycleState.resumed);

    // Check for sessions that need recovery
    _checkForSessionRecovery();

    // Clean up old recovery data
    _persistenceService.cleanupOldRecoveryData();
  }

  void _handleAppPaused() {
    AppLogger.info('App paused');

    // Save current session state
    _saveCurrentSessionState();

    // Save lifecycle state
    _sessionManager.handleAppLifecycleChange(AppLifecycleState.paused);
  }

  void _handleAppInactive() {
    AppLogger.info('App inactive');

    // Save current session state
    _saveCurrentSessionState();

    // Save lifecycle state
    _sessionManager.handleAppLifecycleChange(AppLifecycleState.inactive);
  }

  void _handleAppDetached() {
    AppLogger.info('App detached');

    // Save current session state
    _saveCurrentSessionState();

    // Save lifecycle state
    _sessionManager.handleAppLifecycleChange(AppLifecycleState.detached);
  }

  void _handleAppHidden() {
    AppLogger.info('App hidden');

    // Save current session state
    _saveCurrentSessionState();
  }

  void _saveCurrentSessionState() {
    try {
      // This will be handled by the PersistentWorkoutSessionManager
      // which automatically saves state periodically and on lifecycle changes
      AppLogger.debug('Session state save triggered by lifecycle event');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving session state on lifecycle event',
        e,
        stackTrace,
      );
    }
  }

  Future<void> _checkForSessionRecovery() async {
    try {
      final hasRecoverySessions =
          await _persistenceService.hasSessionsNeedingRecovery();

      if (hasRecoverySessions) {
        AppLogger.info('Found sessions needing recovery');

        // Notify about recovery sessions
        // This could trigger a notification or navigation to recovery screen
        _notifyAboutRecoverySessions();
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error checking for session recovery', e, stackTrace);
    }
  }

  void _notifyAboutRecoverySessions() {
    // This could be implemented to show a notification or navigate to recovery screen
    // For now, just log the information
    AppLogger.info(
      'User has incomplete workout sessions that can be recovered',
    );
  }
}

/// Provider for app lifecycle handler
final appLifecycleHandlerProvider = Provider<AppLifecycleHandler>((ref) {
  // This would need to be properly initialized with the required dependencies
  throw UnimplementedError(
    'AppLifecycleHandler provider needs to be properly configured',
  );
});

/// Service for managing app lifecycle and session persistence
class AppLifecycleService {
  final AppLifecycleHandler _handler;
  bool _isInitialized = false;

  AppLifecycleService({required AppLifecycleHandler handler})
    : _handler = handler;

  /// Initialize the lifecycle service
  void initialize() {
    if (_isInitialized) return;

    _handler.initialize();
    _isInitialized = true;

    AppLogger.info('App lifecycle service initialized');
  }

  /// Dispose the lifecycle service
  void dispose() {
    if (!_isInitialized) return;

    _handler.dispose();
    _isInitialized = false;

    AppLogger.info('App lifecycle service disposed');
  }

  /// Check if the service is initialized
  bool get isInitialized => _isInitialized;
}

/// Extension for app lifecycle state utilities
extension AppLifecycleStateExtension on AppLifecycleState {
  /// Check if the app is in foreground
  bool get isInForeground {
    return this == AppLifecycleState.resumed;
  }

  /// Check if the app is in background
  bool get isInBackground {
    return this == AppLifecycleState.paused ||
        this == AppLifecycleState.inactive ||
        this == AppLifecycleState.detached ||
        this == AppLifecycleState.hidden;
  }

  /// Get a human-readable description
  String get description {
    switch (this) {
      case AppLifecycleState.resumed:
        return 'App is active and in foreground';
      case AppLifecycleState.paused:
        return 'App is paused and in background';
      case AppLifecycleState.inactive:
        return 'App is inactive';
      case AppLifecycleState.detached:
        return 'App is detached';
      case AppLifecycleState.hidden:
        return 'App is hidden';
    }
  }
}

/// Mixin for widgets that need to handle app lifecycle events
mixin AppLifecycleMixin<T extends StatefulWidget> on State<T> {
  late AppLifecycleHandler _lifecycleHandler;

  @override
  void initState() {
    super.initState();
    _initializeLifecycleHandler();
  }

  @override
  void dispose() {
    _lifecycleHandler.dispose();
    super.dispose();
  }

  void _initializeLifecycleHandler() {
    // This would need to be properly implemented based on the specific requirements
    // For now, it's a placeholder
  }

  /// Called when app is resumed
  void onAppResumed() {}

  /// Called when app is paused
  void onAppPaused() {}

  /// Called when app is inactive
  void onAppInactive() {}

  /// Called when app is detached
  void onAppDetached() {}
}
