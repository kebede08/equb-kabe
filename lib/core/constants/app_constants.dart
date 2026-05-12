class AppConstants {
  AppConstants._();

  static const String appName = 'Equb';
  static const String appVersion = '1.0.0';
  static const String baseUrl = 'https://api.equbapp.com/v1';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String languageKey = 'app_language';
  static const String biometricKey = 'biometric_enabled';

  // Supported Languages
  static const String langEnglish = 'en';
  static const String langAmharic = 'am';

  // Pagination
  static const int defaultPageSize = 20;

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // OTP
  static const int otpLength = 6;
  static const int otpResendSeconds = 60;

  // Contribution Status
  static const String statusPending = 'pending';
  static const String statusPaid = 'paid';
  static const String statusLate = 'late';
  static const String statusActive = 'active';
  static const String statusCompleted = 'completed';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleMember = 'member';
  static const String roleSystemAdmin = 'system_admin';

  // Loan Status
  static const String loanPending = 'pending';
  static const String loanApproved = 'approved';
  static const String loanRejected = 'rejected';
  static const String loanPaid = 'paid';

  // Payment Methods
  static const String paymentTelebirr = 'telebirr';
  static const String paymentCBE = 'cbe_birr';
  static const String paymentCash = 'cash';
}
