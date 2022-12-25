import 'package:feed_sx/src/views/feed/components/post/post_media/post_document_list.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_carousel.dart';
import 'package:flutter/cupertino.dart';

class PostMediaFactory extends StatelessWidget {
  final int postType;
  const PostMediaFactory({super.key, required this.postType});

  @override
  Widget build(BuildContext context) {
    return postFactory(postType);
  }

  Widget postFactory(int postType) {
    switch (postType) {
      case 1:
        return PostDocumentList();
      case 2:
        return PostImage();
      case 3:
        return PostMediaCarousel();
      default:
        return SizedBox.shrink();
    }
  }
}
