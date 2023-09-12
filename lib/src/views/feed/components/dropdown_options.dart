import 'package:collection/collection.dart';
import 'package:feed_sx/src/utils/utils.dart';
import 'package:feed_sx/src/views/feed/blocs/new_post/new_post_bloc.dart';
import 'package:feed_sx/src/views/feed/components/post/post_dialog.dart';
import 'package:feed_sx/src/views/edit_post/edit_post_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:overlay_support/overlay_support.dart';

class DropdownOptions extends StatelessWidget {
  final Post postDetails;
  final Map<String, Topic> topics;
  final List<PopupMenuItemModel> menuItems;
  final int feedRoomId;
  final Function(bool) refresh;
  final bool isFeed;

  const DropdownOptions({
    super.key,
    required this.menuItems,
    required this.postDetails,
    required this.refresh,
    required this.feedRoomId,
    required this.topics,
    required this.isFeed,
  });

  @override
  Widget build(BuildContext context) {
    NewPostBloc newPostBloc = BlocProvider.of<NewPostBloc>(context);
    return Builder(builder: (context) {
      return PopupMenuButton<int>(
        onSelected: (value) async {
          if (value == 1) {
            showDialog(
              context: context,
              builder: (childContext) => deleteConfirmationDialog(
                childContext,
                title: 'Delete Post',
                userId: postDetails.userId,
                content:
                    'Are you sure you want to delete this post. This action can not be reversed.',
                action: (String reason) async {
                  Navigator.of(childContext).pop();
                  final res =
                      await locator<LikeMindsService>().getMemberState();
                  //Implement delete post analytics tracking
                  LMAnalytics.get().track(
                    AnalyticsKeys.postDeleted,
                    {
                      "user_state": res.state == 1 ? "CM" : "member",
                      "post_id": postDetails.id,
                      "user_id": postDetails.userId,
                    },
                  );
                  newPostBloc.add(
                    DeletePost(
                      postId: postDetails.id,
                      reason: reason ?? 'Reason',
                      feedRoomId: feedRoomId,
                    ),
                  );

                  if (!isFeed) {
                    locator<NavigationService>().goBack();
                  }
                },
                actionText: 'Delete',
              ),
            );
          } else if (value == 2) {
            debugPrint("Pinning functionality");
            final res = await locator<LikeMindsService>().getMemberState();
            String? postType =
                getPostType(postDetails.attachments?.first.attachmentType ?? 0);
            LMAnalytics.get().track(
              AnalyticsKeys.postUnpinned,
              {
                "user_state": res.state == 1 ? "CM" : "member",
                "post_id": postDetails.id,
                "user_id": postDetails.userId,
                "post_type": postType,
              },
            );
            final response = await locator<LikeMindsService>().pinPost(
              (PinPostRequestBuilder()..postId(postDetails.id)).build(),
            );
            debugPrint(response.toString());
            if (response.success) {
              toast(
                'Post Pinned',
                duration: Toast.LENGTH_LONG,
              );
              refresh(false);
            } else {
              toast(
                response.errorMessage ?? 'An error occurred',
                duration: Toast.LENGTH_LONG,
              );
            }
          } else if (value == 3) {
            debugPrint("Unpinning functionality");
            final res = await locator<LikeMindsService>().getMemberState();
            String? postType =
                getPostType(postDetails.attachments?.first.attachmentType ?? 0);
            LMAnalytics.get().track(
              AnalyticsKeys.postUnpinned,
              {
                "user_state": res.state == 1 ? "CM" : "member",
                "post_id": postDetails.id,
                "user_id": postDetails.userId,
                "post_type": postType,
              },
            );
            final response = await locator<LikeMindsService>().pinPost(
              (PinPostRequestBuilder()..postId(postDetails.id)).build(),
            );
            debugPrint(response.toString());
            if (response.success) {
              toast(
                'Post Unpinned',
                duration: Toast.LENGTH_LONG,
              );
              refresh(false);
            } else {
              toast(
                response.errorMessage ?? 'An error occurred',
                duration: Toast.LENGTH_LONG,
              );
            }
          } else if (value == 5) {
            List<TopicUI> postTopics = [];

            for (String id in postDetails.topics ?? []) {
              if (topics.containsKey(id)) {
                postTopics.add(TopicUI.fromTopic(topics[id]!));
              }
            }
            LMAnalytics.get().track(AnalyticsKeys.postEdited, {
              "created_by_id": postDetails.userId,
              "post_id": postDetails.id,
              "post_type": getPostType(
                  postDetails.attachments?.first.attachmentType ?? 0)
            });

            debugPrint('Editing functionality');
            await locator<NavigationService>().navigateTo(
              EditPostScreen.route,
              arguments: EditPostScreenArguments(
                feedRoomId: feedRoomId,
                postId: postDetails.id,
                selectedTopics: postTopics,
              ),
            );
            await Future.delayed(
              const Duration(
                seconds: 1,
              ),
            );
            refresh(false);
          }
        },
        itemBuilder: (context) => menuItems
            .mapIndexed(
              (index, element) => PopupMenuItem(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                height: 42,
                value: element.id,
                child: Text(element.title),
              ),
            )
            .toList(),
        color: kWhiteColor,
        child: const SizedBox(
          height: 24,
          width: 24,
          child: Icon(
            Icons.more_horiz,
            color: kGrey1Color,
            size: 24,
          ),
        ),
      );
    });
  }
}
