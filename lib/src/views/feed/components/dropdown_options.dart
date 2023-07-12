import 'package:collection/collection.dart';
import 'package:feed_sx/src/views/feed/components/post/post_dialog.dart';
import 'package:feed_sx/src/views/edit_post/edit_post_screen.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class DropdownOptions extends StatelessWidget {
  final Post postDetails;
  final List<PopupMenuItemModel> menuItems;
  final int feedRoomId;
  final Function(bool) refresh;

  const DropdownOptions({
    super.key,
    required this.menuItems,
    required this.postDetails,
    required this.refresh,
    required this.feedRoomId,
  });

  @override
  Widget build(BuildContext context) {
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
                  final response = await locator<LikeMindsService>().deletePost(
                    (DeletePostRequestBuilder()
                          ..postId(postDetails.id)
                          ..deleteReason(
                            reason.isEmpty ? "Reason for deletion" : reason,
                          ))
                        .build(),
                  );
                  print(response.toString());

                  if (response.success) {
                    toast(
                      'Post Deleted',
                      duration: Toast.LENGTH_LONG,
                    );
                    refresh(true);
                  } else {
                    toast(
                      response.errorMessage ?? 'An error occurred',
                      duration: Toast.LENGTH_LONG,
                    );
                  }
                },
                actionText: 'Delete',
              ),
            );
          } else if (value == 2) {
            print("Pinning functionality");
            final res = await locator<LikeMindsService>().getMemberState();
            LMAnalytics.get().track(
              AnalyticsKeys.postPinned,
              {
                "user_state": res.state == 1 ? "CM" : "member",
                "post_id": postDetails.id,
                "user_id": postDetails.userId,
              },
            );
            final response = await locator<LikeMindsService>().pinPost(
              (PinPostRequestBuilder()..postId(postDetails.id)).build(),
            );
            print(response.toString());
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
            print("Unpinning functionality");
            final res = await locator<LikeMindsService>().getMemberState();
            LMAnalytics.get().track(
              AnalyticsKeys.postUnpinned,
              {
                "user_state": res.state == 1 ? "CM" : "member",
                "post_id": postDetails.id,
                "user_id": postDetails.userId,
              },
            );
            final response = await locator<LikeMindsService>().pinPost(
              (PinPostRequestBuilder()..postId(postDetails.id)).build(),
            );
            print(response.toString());
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
            print('Editing functionality');
            await locator<NavigationService>().navigateTo(
              EditPostScreen.route,
              arguments: EditPostScreenArguments(
                feedRoomId: feedRoomId,
                postId: postDetails.id,
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
