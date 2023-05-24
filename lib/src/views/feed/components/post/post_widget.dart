import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_factory.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final Post postDetails;
  final int feedRoomId;
  final User user;
  final bool showActions;
  final Function(bool) refresh;
  final bool isFeed;

  const PostWidget({
    super.key,
    this.showActions = true,
    required this.postDetails,
    required this.feedRoomId,
    required this.user,
    required this.refresh,
    this.isFeed = true,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Post? postDetails;
  late final User user;
  late final bool showActions;
  Function(bool)? refresh;
  late bool isFeed;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    showActions = widget.showActions;
    isFeed = widget.isFeed;
  }

  void setPostValues() {
    refresh = widget.refresh;
    postDetails = widget.postDetails;
  }

  @override
  Widget build(BuildContext context) {
    setPostValues();
    return GestureDetector(
      onTap: () {
        if (isFeed) {
          locator<NavigationService>().navigateTo(
            AllCommentsScreen.route,
            arguments: AllCommentsScreenArguments(
              postId: postDetails!.id,
              feedRoomId: widget.feedRoomId,
              fromComment: false,
            ),
          );
        }
      },
      child: Padding(
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
                refresh: refresh!,
                feedRoomId: widget.feedRoomId,
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
                      refresh: refresh!,
                      isFeed: isFeed,
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
