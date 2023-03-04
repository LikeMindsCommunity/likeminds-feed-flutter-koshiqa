import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/previews/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class PostImage extends StatelessWidget {
  final String postId;
  final String url;
  const PostImage({
    super.key,
    required this.url,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return url.isEmpty
        ? const SizedBox.shrink()
        : AspectRatio(
            aspectRatio: 360.0 / 296.0,
            child: GestureDetector(
              onTap: () {
                LMAnalytics.get().track(AnalyticsKeys.clickedOnAttachment, {
                  "post_id": postId,
                  "type": "photo",
                });
                locator<NavigationService>().navigateTo(
                  ImagePreview.route,
                  arguments: ImagePreviewArguments(
                    url: url,
                    postId: postId,
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: kPaddingMedium),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              ),
            ));
  }
}
