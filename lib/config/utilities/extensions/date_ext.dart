import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String get formattedDate => DateFormat.yMMMMd().format(this);
  String get formattedTime => DateFormat.jm().format(this);
  String get formattedDateTime => DateFormat.yMMMMd().add_jm().format(this);
}
