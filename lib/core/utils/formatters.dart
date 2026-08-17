import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

abstract class AppFormatters {
  static String currency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: AppConstants.currencySymbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String date(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String time(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String dateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  static String distance(double km) {
    return '${km.toStringAsFixed(1)} km';
  }
}
