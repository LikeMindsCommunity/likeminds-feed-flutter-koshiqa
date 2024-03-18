import 'dart:ui';

import 'package:likeminds_feed_flutter_koshiqa/src/utils/constants/ui_constants.dart';
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

String? getPostType(int postType) {
  String? postTypeString;
  switch (postType) {
    case 1: // Image
      postTypeString = "image";
      break;
    case 2: // Video
      postTypeString = "video";
      break;
    case 3: // Document
      postTypeString = "document";
      break;
    case 4: // Link
      postTypeString = "link";
      break;
  }
  return postTypeString;
}
