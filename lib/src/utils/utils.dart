import 'dart:ui';

import 'package:feed_sx/src/utils/constants/ui_constants.dart';

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
    final difference = DateTime.now().difference(this);
    if (difference.inDays > 365) {
      return (difference.inDays / 365).floor().toString() + 'y';
    } else if (difference.inDays > 30) {
      return (difference.inDays / 30).floor().toString() + 'm';
    } else if (difference.inDays > 0) {
      return difference.inDays.toString() + 'd';
    } else if (difference.inHours > 0) {
      return difference.inHours.toString() + 'h';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes.toString() + 'm';
    } else if (difference.inSeconds > 0) {
      return difference.inSeconds.toString() + 's';
    } else {
      return 'now';
    }
  }
}
