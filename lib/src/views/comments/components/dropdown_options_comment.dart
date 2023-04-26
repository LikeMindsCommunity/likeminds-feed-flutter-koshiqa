import 'package:collection/collection.dart';
import 'package:feed_sx/src/views/comments/blocs/add_comment/add_comment_bloc.dart';
import 'package:feed_sx/src/views/feed/components/post/post_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class DropdownOptionsComments extends StatelessWidget {
  final String postId;
  final Reply replyDetails;
  final List<PopupMenuItemModel> menuItems;
  final Function() refresh;

  const DropdownOptionsComments({
    super.key,
    required this.menuItems,
    required this.replyDetails,
    required this.refresh,
    required this.postId,
  });

  void removeReportIntegration() {
    menuItems.removeWhere((element) {
      if (element.id == 7) {
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AddCommentBloc addCommentBloc = BlocProvider.of<AddCommentBloc>(context);
    removeReportIntegration();
    return Builder(builder: (context) {
      return PopupMenuButton<int>(
        onSelected: (value) async {
          print(value);
          if (value == 6) {
            showDialog(
                context: context,
                builder: (childContext) => deleteConfirmationDialog(
                        childContext,
                        title: 'Delete Comment',
                        userId: replyDetails.userId,
                        content:
                            'Are you sure you want to delete this comment. This action can not be reversed.',
                        action: (String reason) async {
                      Navigator.of(childContext).pop();
                      //Implement delete post analytics tracking
                      LMAnalytics.get().track(
                        AnalyticsKeys.commentDeleted,
                        {
                          "post_id": postId,
                          "comment_id": replyDetails.id,
                        },
                      );
                      final response =
                          await locator<LikeMindsService>().deleteComment(
                        (DeleteCommentRequestBuilder()
                              ..postId(postId)
                              ..commentId(replyDetails.id)
                              ..reason(reason.isEmpty
                                  ? "Reason for deletion"
                                  : reason))
                            .build(),
                      );

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
          } else if (value == 7) {
            print("Report functionality");
          } else if (value == 8) {
            print('Editing functionality');
            addCommentBloc.add(EditCommentCancel());
            addCommentBloc.add(
              EditingComment(
                commentId: replyDetails.id,
                text: replyDetails.text,
              ),
            );
          }
        },
        itemBuilder: (context) => menuItems
            .mapIndexed((index, element) => PopupMenuItem(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  height: 42,
                  value: element.id,
                  child: Text(element.title),
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
