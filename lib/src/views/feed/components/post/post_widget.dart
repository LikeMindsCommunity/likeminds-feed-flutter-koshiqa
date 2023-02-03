import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/comments/all_comments_screen.dart';
import 'package:feed_sx/src/views/feed/components/post/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_factory.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final Post postDetails;
  final PostUser user;
  final int postType;
  final bool showActions;
  const PostWidget({
    super.key,
    required this.postType,
    this.showActions = true,
    required this.postDetails,
    required this.user,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final postDetails = widget.postDetails;
    final user = widget.user;
    final showActions = widget.showActions;

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
                ? PostActions(postDetails: postDetails, refresh: refresh)
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

// class PostWidget extends StatelessWidget {
//   const PostWidget({
//     super.key,
//     required this.postType,
//     this.showActions = true,
//     required this.postDetails,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
    
//   }
// }
