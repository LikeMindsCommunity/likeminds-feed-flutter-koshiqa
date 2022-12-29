import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_factory.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final int postType;
  const PostWidget({super.key, required this.postType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        color: kWhiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PostHeader(),
            PostDescription(
              text:
                  'This text contains tags and links : https://likeminds.community/  and @Suryansh',
            ),
            PostMediaFactory(postType: postType),
            PostActions()
          ],
        ),
      ),
    );
  }
}
