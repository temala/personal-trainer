/// Input validation utilities
class Validators {
  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!value.contains(RegExp('[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp('[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp('[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Name validation
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }

    return null;
  }

  /// Age validation
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < 13) {
      return 'You must be at least 13 years old';
    }

    if (age > 120) {
      return 'Please enter a valid age';
    }

    return null;
  }

  /// Weight validation (in kg)
  static String? weight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid weight';
    }

    if (weight < 20) {
      return 'Weight must be at least 20 kg';
    }

    if (weight > 500) {
      return 'Please enter a valid weight';
    }

    return null;
  }

  /// Height validation (in cm)
  static String? height(String? value) {
    if (value == null || value.isEmpty) {
      return 'Height is required';
    }

    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid height';
    }

    if (height < 100) {
      return 'Height must be at least 100 cm';
    }

    if (height > 250) {
      return 'Please enter a valid height';
    }

    return null;
  }

  /// Target weight validation
  static String? targetWeight(String? value, double? currentWeight) {
    if (value == null || value.isEmpty) {
      return 'Target weight is required';
    }

    final targetWeight = double.tryParse(value);
    if (targetWeight == null) {
      return 'Please enter a valid target weight';
    }

    if (targetWeight < 20) {
      return 'Target weight must be at least 20 kg';
    }

    if (targetWeight > 500) {
      return 'Please enter a valid target weight';
    }

    if (currentWeight != null && (targetWeight - currentWeight).abs() > 100) {
      return 'Target weight seems unrealistic';
    }

    return null;
  }

  /// Generic required field validation
  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Numeric validation
  static String? numeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number for $fieldName';
    }

    return null;
  }
}
