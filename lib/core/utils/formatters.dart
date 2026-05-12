import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currencyFormat = NumberFormat('#,##0.00', 'en_US');
  static final _dateFormat = DateFormat('MMM dd, yyyy');
  static final _dateTimeFormat = DateFormat('MMM dd, yyyy HH:mm');
  static final _shortDateFormat = DateFormat('dd/MM/yyyy');

  /// Format amount as Ethiopian Birr
  static String formatBirr(double amount) {
    return 'ETB ${_currencyFormat.format(amount)}';
  }

  /// Format amount with comma separators
  static String formatAmount(double amount) {
    return _currencyFormat.format(amount);
  }

  /// Format date to readable string
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Format short date
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Format phone number for display
  static String formatPhone(String phone) {
    if (phone.startsWith('+251')) {
      final local = phone.substring(4);
      return '+251 ${local.substring(0, 2)} ${local.substring(2, 5)} ${local.substring(5)}';
    }
    return phone;
  }

  /// Format cycle duration
  static String formatCycleDuration(int months) {
    if (months == 1) return '1 Month';
    return '$months Months';
  }

  /// Format percentage
  static String formatPercent(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  /// Mask phone number for privacy
  static String maskPhone(String phone) {
    if (phone.length < 6) return phone;
    return '${phone.substring(0, 4)}****${phone.substring(phone.length - 3)}';
  }
}
