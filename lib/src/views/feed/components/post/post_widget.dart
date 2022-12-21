import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post/post_image.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        color: kWhiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            PostHeader(),
            PostDescription(),
            PostImage(),
            PostActions()
          ],
        ),
      ),
    );
  }
}
