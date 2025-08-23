import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fitness_training_app/core/errors/app_error.dart';
import 'package:logger/logger.dart';

/// Global error handler for the application
class ErrorHandler {
  static final Logger _logger = Logger();
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Handle application errors based on severity
  static void handleError(AppError error, {StackTrace? stackTrace}) {
    // Log the error
    _logError(error, stackTrace);

    // Report to Crashlytics based on severity
    _reportToCrashlytics(error, stackTrace);

    // Additional handling based on error type
    _handleSpecificError(error);
  }

  /// Log error to console and local storage
  static void _logError(AppError error, StackTrace? stackTrace) {
    final message = 'AppError: ${error.message}';

    switch (error.severity) {
      case ErrorSeverity.critical:
        _logger.e(message, error: error, stackTrace: stackTrace);
      case ErrorSeverity.warning:
        _logger.w(message, error: error, stackTrace: stackTrace);
      case ErrorSeverity.info:
        _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Report critical errors to Firebase Crashlytics
  static void _reportToCrashlytics(AppError error, StackTrace? stackTrace) {
    if (error.severity == ErrorSeverity.critical) {
      _crashlytics.recordError(
        error,
        stackTrace,
        information: [
          DiagnosticsProperty('error_type', error.runtimeType.toString()),
          DiagnosticsProperty('error_code', error.code),
          DiagnosticsProperty('context', error.context),
        ],
      );
    }
  }

  /// Handle specific error types with custom logic
  static void _handleSpecificError(AppError error) {
    error.when(
      network: (message, code, severity, context) {
        // Could trigger offline mode or retry logic
      },
      authentication: (message, code, severity, context) {
        // Could trigger logout or re-authentication flow
      },
      permission: (message, code, severity, context) {
        // Could show permission request dialog
      },
      storage: (message, code, severity, context) {
        // Could trigger data recovery or cleanup
      },
      ai: (message, code, severity, context) {
        // Could switch to fallback AI provider
      },
      subscription: (message, code, severity, context) {
        // Could refresh subscription status
      },
      animation: (message, code, severity, context) {
        // Could fallback to static images
      },
      validation: (message, code, severity, context) {
        // Could highlight invalid fields
      },
      unknown: (message, code, severity, context) {
        // Generic error handling
      },
    );
  }

  /// Convert generic exceptions to AppError
  static AppError fromException(dynamic exception, {StackTrace? stackTrace}) {
    if (exception is AppError) {
      return exception;
    }

    // Map common exceptions to AppError types
    if (exception.toString().contains('SocketException') ||
        exception.toString().contains('TimeoutException')) {
      return const AppError.network(
        message: 'Network connection failed',
        code: 'NETWORK_ERROR',
      );
    }

    if (exception.toString().contains('FirebaseAuth')) {
      return const AppError.authentication(
        message: 'Authentication failed',
        code: 'AUTH_ERROR',
      );
    }

    // Default to unknown error
    return AppError.unknown(
      message: exception.toString(),
      code: 'UNKNOWN_ERROR',
      context: {'exception_type': exception.runtimeType.toString()},
    );
  }
}

/// Extension to add error handling to DiagnosticsProperty
class DiagnosticsProperty<T> {
  DiagnosticsProperty(this.name, this.value);
  final String name;
  final T value;
}
