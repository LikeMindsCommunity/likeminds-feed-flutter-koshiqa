import 'dart:ui';

import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:timeago/timeago.dart';

extension StringColor on String {
  Color? toColor() {
    // if (primaryColor != null) {
    if (int.tryParse(this) != null) {
      return Color(int.tryParse(this)!);
    } else {
      return kPrimaryColor;
    }
  }
}

// Convert DateTime to Time Ago String
extension DateTimeAgo on DateTime {
  String timeAgo() {
    return format(this);
  }
}
