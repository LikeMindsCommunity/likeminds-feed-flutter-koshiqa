import 'package:collection/collection.dart';
import 'package:feed_sx/src/views/feed/components/post/post_dialog.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/report_post/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:likeminds_feed/likeminds_feed.dart' as sdk;
import 'package:overlay_support/overlay_support.dart';

class DropdownOptionsComments extends StatelessWidget {
  final String postId;
  final Reply replyDetails;
  final List<PopupMenuItemModel> menuItems;
  final Function() refresh;

  DropdownOptionsComments({
    super.key,
    required this.menuItems,
    required this.replyDetails,
    required this.refresh,
    required this.postId,
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
                                  title: 'Delete Comment',
                                  content:
                                      'Are you sure you want to delete this comment. This action can not be reversed.',
                                  action: () async {
                                Navigator.of(childContext).pop();
                                final res = await locator<LikeMindsService>()
                                    .getMemberState();
                                //Implement delete post analytics tracking
                                LMAnalytics.get().track(
                                  AnalyticsKeys.commentDeleted,
                                  {
                                    "post_id": postId,
                                    "comment_id": replyDetails.id,
                                  },
                                );
                                final response =
                                    await locator<LikeMindsService>()
                                        .deleteComment(
                                  (DeleteCommentRequestBuilder()
                                        ..postId(postId)
                                        ..commentId(replyDetails.id)
                                        ..reason("Reason for deletion"))
                                      .build(),
                                );
                                print(response.toString());

                                if (response.success) {
                                  toast(
                                    'Comment Deleted',
                                    duration: Toast.LENGTH_LONG,
                                  );
                                  refresh();
                                } else {
                                  toast(
                                    response.errorMessage ?? '',
                                    duration: Toast.LENGTH_LONG,
                                  );
                                }
                              }, actionText: 'Delete'));
                    } else if (element.title.split(' ').first == "Pin") {
                      print("Pinning functionality");
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
