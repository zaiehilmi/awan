import 'package:intl/intl.dart';

extension FormatMasa on DateTime {
  String get format24Jam => DateFormat('HH:mm').format(this);
}
