import 'package:intl/intl.dart';

class FormatUtils {
  static String currency(double value) {
    return NumberFormat('#,##0.00', 'en_US').format(value);
  }

  static String number(int value) {
    return NumberFormat.decimalPattern('en_US').format(value);
  }
}
