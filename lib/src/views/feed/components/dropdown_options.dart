import 'package:collection/collection.dart';
import 'package:feed_sx/src/views/feed/components/post/post_dialog.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class DropdownOptions extends StatelessWidget {
  final Post postDetails;
  final List<PopupMenuItemModel> menuItems;
  final Function(bool) refresh;

  DropdownOptions({
    super.key,
    required this.menuItems,
    required this.postDetails,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      return PopupMenuButton<int>(
        itemBuilder: (context) => menuItems
            .mapIndexed((index, element) => PopupMenuItem(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  height: 42,
                  value: index,
                  child: Text(element.title),
                  onTap: () async {
                    if (element.title.split(' ').first == "Delete") {
                      showDialog(
                          context: context,
                          builder: (childContext) => confirmationDialog(
                                  childContext,
                                  title: 'Delete Post',
                                  content:
                                      'Are you sure you want to delete this post. This action can not be reversed.',
                                  action: () async {
                                Navigator.of(childContext).pop();
                                final res = await locator<LikeMindsService>()
                                    .getMemberState();
                                //Implement delete post analytics tracking
                                LMAnalytics.get().track(
                                  AnalyticsKeys.postDeleted,
                                  {
                                    "user_state": res ? "CM" : "member",
                                    "post_id": postDetails.id,
                                    "user_id": postDetails.userId,
                                  },
                                );
                                final response =
                                    await locator<LikeMindsService>()
                                        .deletePost(
                                  DeletePostRequest(
                                    postId: postDetails.id,
                                    deleteReason: "deleteReason",
                                  ),
                                );
                                print(response.toString());

                                if (response.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      confirmationToast(
                                          content: 'Post Deleted',
                                          width: 200,
                                          backgroundColor: kGrey1Color));
                                  refresh(true);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      confirmationToast(
                                          content: response.errorMessage ??
                                              'An error occurred',
                                          backgroundColor: kGrey1Color));
                                }
                              }, actionText: 'Delete'));
                    } else if (element.title.split(' ').first == "Pin" ||
                        element.title.split(' ').first == "Unpin") {
                      print("Pinning functionality");
                      final res =
                          await locator<LikeMindsService>().getMemberState();
                      LMAnalytics.get().track(
                        element.title.split(' ').first == "Pin"
                            ? AnalyticsKeys.postPinned
                            : AnalyticsKeys.postUnpinned,
                        {
                          "user_state": res ? "CM" : "member",
                          "post_id": postDetails.id,
                          "user_id": postDetails.userId,
                        },
                      );
                      final response =
                          await locator<LikeMindsService>().pinPost(
                        PinPostRequest(
                          postId: postDetails.id,
                        ),
                      );
                      print(response.toString());
                      if (response.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          confirmationToast(
                            content: element.title.split(' ').first == "Pin"
                                ? 'Post Pinned'
                                : 'Post Unpinned',
                            width: 200,
                            backgroundColor: kGrey1Color,
                          ),
                        );
                        refresh(false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          confirmationToast(
                            content:
                                response.errorMessage ?? 'An error occurred',
                            backgroundColor: kGrey1Color,
                          ),
                        );
                      }
                    }
                  },
                ))
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
