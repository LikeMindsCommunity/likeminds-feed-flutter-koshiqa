import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_document_list.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_carousel.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_video.dart';
import 'package:flutter/cupertino.dart';

class PostMediaFactory extends StatelessWidget {
  // final int postType;
  final List<Attachment>? attachments;
  const PostMediaFactory({super.key, this.attachments});

  @override
  Widget build(BuildContext context) {
    if (attachments == null) return SizedBox.shrink();
    return attachments?.length == 1
        ? PostImage(url: attachments![0].attachmentMeta.url ?? "")
        : PostMediaCarousel(
            urls: attachments!.map((e) => e.attachmentMeta.url ?? "").toList());
  }

  Widget postFactory(int postType) {
    switch (postType) {
      case 1:
        return PostDocumentList();
      case 2:
        return PostImage(
          url: 'https://wallpaperaccess.com/full/2637581.jpg',
        );
      // case 3:
      // return PostMediaCarousel();
      case 4:
        return PostVideo(
            url:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
      default:
        return SizedBox.shrink();
    }
  }
}
