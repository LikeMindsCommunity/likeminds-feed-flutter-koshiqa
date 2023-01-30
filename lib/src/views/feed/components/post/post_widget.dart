import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_factory.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final Post postDetails;
  final PostUser user;
  final int postType;
  final bool showActions;
  const PostWidget(
      {super.key,
      required this.postType,
      this.showActions = true,
      required this.postDetails,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        color: kWhiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(
                user: user,
                menuItems: postDetails.menuItems,
                postDetails: postDetails),
            PostDescription(
              text: postDetails.text,
            ),
            PostMediaFactory(attachments: postDetails.attachments),
            showActions
                ? PostActions(
                    postId: postDetails.id,
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
