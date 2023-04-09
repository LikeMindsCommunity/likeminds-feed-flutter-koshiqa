import 'dart:io';
import 'package:feed_sx/src/utils/credentials/credentials.dart';

import 'package:simple_s3/simple_s3.dart';

bool isProdFlag = true;

class MediaService {
  final String _bucketName;
  final String _poolId;
  final _region = AWSRegions.apSouth1;
  final SimpleS3 _s3Client = SimpleS3();

  MediaService(this._bucketName, this._poolId);

  String get bucketName => _bucketName;

  String get poolId => _poolId;

  get region => _region;

  SimpleS3 get s3Client => _s3Client;
}

class MediaUpload {
  MediaService mediaService = MediaService(
    isProdFlag ? CredsProd.bucketName : CredsDev.bucketName,
    isProdFlag ? CredsProd.poolId : CredsDev.poolId,
  );

  MediaUpload();

  Future<String?> uploadFile(File file) async {
    try {
      String result = await mediaService.s3Client.uploadFile(
        file,
        mediaService.bucketName,
        mediaService.poolId,
        mediaService.region,
      );
      return result;
    } on SimpleS3Errors catch (e) {
      print(e.toString());
      return null;
    }
  }
}
