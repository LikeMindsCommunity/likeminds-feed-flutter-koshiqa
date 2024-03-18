import 'package:collection/collection.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/views/comments/blocs/add_comment_reply/add_comment_reply_bloc.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/views/feed/components/post/post_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_feed_flutter_koshiqa/feed.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class DropdownOptionsReply extends StatelessWidget {
  final String postId;
  final String commentId;
  final CommentReply replyDetails;
  final List<PopupMenuItemModel> menuItems;
  final Function() refresh;

  const DropdownOptionsReply({
    super.key,
    required this.menuItems,
    required this.replyDetails,
    required this.refresh,
    required this.postId,
    required this.commentId,
  });

  void removeEditIntegration() {
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
    removeEditIntegration();
    AddCommentReplyBloc addCommentReplyBloc =
        BlocProvider.of<AddCommentReplyBloc>(context);
    return Builder(builder: (context) {
      if (menuItems.isEmpty) {
        return Container();
      }
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
                    AnalyticsKeys.replyDeleted,
                    {
                      "post_id": postId,
                      "comment_id": commentId,
                      "reply_id": replyDetails.id,
                    },
                  );
                  addCommentReplyBloc.add(DeleteCommentReply(
                      (DeleteCommentRequestBuilder()
                            ..postId(postId)
                            ..commentId(replyDetails.id)
                            ..reason(reason.isEmpty
                                ? "Reason for deletion"
                                : reason))
                          .build()));
                },
                actionText: 'Delete',
              ),
            );
          } else if (value == 7) {
            print("Report functionality");
          } else if (value == 8) {
            print("Editing functionality");
            addCommentReplyBloc.add(EditReplyCancel());
            addCommentReplyBloc.add(
              EditingReply(
                commentId: commentId,
                text: replyDetails.text,
                replyId: replyDetails.id,
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
