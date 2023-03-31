import 'dart:io';

import 'package:likeminds_feed/likeminds_feed.dart';

enum MediaType { video, image, document, link }

class MediaModel {
  MediaType mediaType;
  File? mediaFile;
  String? link;
  int? duration;
  String? format;
  int? size;
  AttachmentMetaOgTags? ogTags;

  MediaModel({
    required this.mediaType,
    this.mediaFile,
    this.link,
    this.duration,
    this.format,
    this.size,
    this.ogTags,
  });

  int mapMediaTypeToInt() {
    if (mediaType == MediaType.image) {
      return 1;
    } else if (mediaType == MediaType.video) {
      return 2;
    } else {
      return 3;
    }
  }
}
