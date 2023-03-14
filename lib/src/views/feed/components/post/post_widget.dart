import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_factory.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final Post postDetails;
  final PostUser user;
  final int postType;
  final bool showActions;
  final Function(bool) refresh;
  final bool isFeed;

  const PostWidget({
    super.key,
    required this.postType,
    this.showActions = true,
    required this.postDetails,
    required this.user,
    required this.refresh,
    this.isFeed = true,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Post? postDetails;
  late final PostUser user;
  late final bool showActions;
  late final Function(bool) refresh;
  late bool isFeed;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    showActions = widget.showActions;
    refresh = widget.refresh;
    isFeed = widget.isFeed;
  }

  setPostValues() {
    postDetails = widget.postDetails;
  }

  @override
  Widget build(BuildContext context) {
    setPostValues();
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
              menuItems: postDetails!.menuItems,
              postDetails: postDetails!,
              refresh: refresh,
            ),
            PostDescription(
              text: postDetails!.text,
            ),
            PostMediaFactory(
              attachments: postDetails!.attachments,
              postId: postDetails!.id,
            ),
            showActions
                ? PostActions(
                    postDetails: postDetails!,
                    refresh: refresh,
                    isFeed: isFeed,
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
