import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/views/feed/components/post/post_topic.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_factory.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart' as ui;

class PostWidget extends StatefulWidget {
  final Post postDetails;
  final int feedRoomId;
  final User user;
  final Map<String, Topic> topics;
  final bool showActions;
  final Function(bool) refresh;
  final bool isFeed;
  final bool showTopic;

  const PostWidget({
    super.key,
    this.showActions = true,
    required this.postDetails,
    required this.feedRoomId,
    required this.user,
    required this.refresh,
    required this.topics,
    this.showTopic = true,
    this.isFeed = true,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Post? postDetails;
  User? user;
  bool? showActions;
  Function(bool)? refresh;
  bool? isFeed;
  List<ui.TopicUI>? postTopics;

  void setPostValues() {
    refresh = widget.refresh;
    user = widget.user;
    postDetails = widget.postDetails;
    showActions = widget.showActions;
    isFeed = widget.isFeed;
    postTopics = [];
    for (String id in postDetails!.topics ?? []) {
      if (widget.topics.containsKey(id)) {
        postTopics!.add(ui.TopicUI.fromTopic(widget.topics[id]!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setPostValues();
    return GestureDetector(
      onTap: () {
        if (isFeed!) {
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
                user: user!,
                menuItems: postDetails!.menuItems,
                postDetails: postDetails!,
                refresh: refresh!,
                feedRoomId: widget.feedRoomId,
                topics: widget.topics,
                isFeed: widget.isFeed,
              ),
              postTopics != null && postTopics!.isNotEmpty
                  ? kVerticalPaddingMedium
                  : const SizedBox(),
              PostTopic(postTopics: postTopics ?? <ui.TopicUI>[]),
              PostDescription(
                text: postDetails!.text,
              ),
              PostMediaFactory(
                attachments: postDetails!.attachments,
                post: postDetails!,
              ),
              showActions!
                  ? PostActions(
                      postDetails: postDetails!,
                      refresh: refresh!,
                      isFeed: isFeed!,
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
