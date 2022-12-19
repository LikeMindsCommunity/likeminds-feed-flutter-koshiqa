import 'dart:ui';

import 'package:feed_sx/src/theme.dart';

extension StringColor on String {
  Color? toColor() {
    // if (primaryColor != null) {
    if (int.tryParse(this) != null) {
      return Color(int.tryParse(this)!);
    } else {
      return kprimaryColor;
    }
  }
}
