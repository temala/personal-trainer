import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

/// Base class for all application errors
@freezed
class AppError with _$AppError {
  const factory AppError.network({
    required String message,
    String? code,
    @Default(ErrorSeverity.warning) ErrorSeverity severity,
    Map<String, dynamic>? context,
  }) = NetworkError;

  const factory AppError.authentication({
    required String message,
    String? code,
    @Default(ErrorSeverity.critical) ErrorSeverity severity,
    Map<String, dynamic>? context,
  }) = AuthenticationError;

  const factory AppError.permission({
    required String message,
    String? code,
    @Default(ErrorSeverity.warning) ErrorSeverity severity,
    Map<String, dynamic>? context,
  }) = PermissionError;

  const factory AppError.storage({
    required String message,
    String? code,
    @Default(ErrorSeverity.warning) ErrorSeverity severity,
    Map<String, dynamic>? context,
  }) = StorageError;

  const factory AppError.ai({
    required String message,
    String? code,
    @Default(ErrorSeverity.warning) ErrorSeverity severity,
    Map<String, dynamic>? context,
  }) = AIError;

  const factory AppError.subscription({
    required String message,
    String? code,
    @Default(ErrorSeverity.warning) ErrorSeverity severity,
    Map<String, dynamic>? context,
  }) = SubscriptionError;

  const factory AppError.animation({
    required String message,
    String? code,
    @Default(ErrorSeverity.info) ErrorSeverity severity,
    Map<String, dynamic>? context,
  }) = AnimationError;

  const factory AppError.validation({
    required String message,
    String? code,
    @Default(ErrorSeverity.warning) ErrorSeverity severity,
    Map<String, dynamic>? context,
  }) = ValidationError;

  const factory AppError.unknown({
    required String message,
    String? code,
    @Default(ErrorSeverity.critical) ErrorSeverity severity,
    Map<String, dynamic>? context,
  }) = UnknownError;
}

/// Error severity levels
enum ErrorSeverity { info, warning, critical }

/// Extension to provide user-friendly error messages
extension AppErrorExtension on AppError {
  String get userMessage {
    return when(
      network:
          (message, code, severity, context) =>
              'Network connection issue. Please check your internet connection.',
      authentication:
          (message, code, severity, context) =>
              'Authentication failed. Please try logging in again.',
      permission:
          (message, code, severity, context) =>
              'Permission required. Please grant the necessary permissions.',
      storage:
          (message, code, severity, context) =>
              'Storage error occurred. Please try again.',
      ai:
          (message, code, severity, context) =>
              'AI service temporarily unavailable. Please try again.',
      subscription:
          (message, code, severity, context) =>
              'Subscription error. Please check your subscription status.',
      animation:
          (message, code, severity, context) =>
              'Animation loading failed. Continuing without animation.',
      validation:
          (message, code, severity, context) =>
              'Please check your input and try again.',
      unknown:
          (message, code, severity, context) =>
              'An unexpected error occurred. Please try again.',
    );
  }
}
