import 'dart:io';

enum MediaType { video, image, document }

class MediaModel {
  MediaType mediaType;
  File mediaFile;
  int? duration;
  String? format;
  int? size;

  MediaModel({
    required this.mediaType,
    required this.mediaFile,
    this.duration,
    this.format,
    this.size,
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
