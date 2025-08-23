/// Specific error class for AI service operations
class AIServiceError extends Error {
  final String message;
  final String? code;
  final Map<String, dynamic>? context;

  AIServiceError(this.message, {this.code, this.context});

  @override
  String toString() {
    return 'AIServiceError: $message${code != null ? ' (Code: $code)' : ''}';
  }
}
