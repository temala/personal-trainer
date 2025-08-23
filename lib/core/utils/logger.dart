import 'package:logger/logger.dart';

/// Application logger configuration
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error message
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.f(message, error: error, stackTrace: stackTrace);
  }
}
