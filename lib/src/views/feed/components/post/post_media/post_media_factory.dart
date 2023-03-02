import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image.dart';
import 'package:flutter/cupertino.dart';

class PostMediaFactory extends StatelessWidget {
  final String postId;
  final List<Attachment>? attachments;

  const PostMediaFactory({
    super.key,
    this.attachments,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    if (attachments == null) return const SizedBox.shrink();
    return PostImage(
      url: attachments!.map((e) => e.attachmentMeta.url ?? "").toList(),
      postId: postId,
    );
  }

  // Widget postFactory(int postType) {
  //   switch (postType) {
  //     case 1:
  //       return PostDocumentList();
  //     case 2:
  //       return PostImage(
  //         url: 'https://wallpaperaccess.com/full/2637581.jpg',
  //         postId: postId,
  //       );
  //     // case 3:
  //     // return PostMediaCarousel();
  //     case 4:
  //       return PostVideo(
  //           url:
  //               'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
  //     default:
  //       return const SizedBox.shrink();
  //   }
  // }
}
