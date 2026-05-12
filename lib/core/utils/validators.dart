class Validators {
  Validators._();

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final phoneRegex = RegExp(r'^(\+251|0)[79]\d{8}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid Ethiopian phone number';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return null; // email is optional
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) return 'Full name is required';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) return 'Amount is required';
    final amount = double.tryParse(value);
    if (amount == null) return 'Enter a valid amount';
    if (amount <= 0) return 'Amount must be greater than 0';
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }

  static String? validateGroupName(String? value) {
    if (value == null || value.isEmpty) return 'Group name is required';
    if (value.trim().length < 3) return 'Group name must be at least 3 characters';
    return null;
  }

  static String? validateMembers(String? value) {
    if (value == null || value.isEmpty) return 'Number of members is required';
    final count = int.tryParse(value);
    if (count == null) return 'Enter a valid number';
    if (count < 2) return 'Group must have at least 2 members';
    if (count > 100) return 'Group cannot exceed 100 members';
    return null;
  }
}
