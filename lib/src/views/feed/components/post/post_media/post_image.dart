import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  final String url;
  const PostImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return url.isEmpty
        ? SizedBox.shrink()
        : AspectRatio(
            aspectRatio: 360.0 / 296.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: kPaddingMedium),
              child: Image.network(
                url,
                fit: BoxFit.cover,
              ),
            ));
  }
}
