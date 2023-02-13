import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatefulWidget {
  static const route = '/image_preview';
  final String url;
  final String postId;

  const ImagePreview({
    super.key,
    required this.url,
    required this.postId,
  });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Image Preview'),
        leading: BackButton(),
      ),
      body: Center(
          child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          vertical: kPaddingMedium,
          horizontal: kPaddingMedium,
        ),
        child: PhotoView(
          imageProvider: NetworkImage(widget.url),
          backgroundDecoration: const BoxDecoration(color: kWhiteColor),
        ),
      )),
    );
  }
}
