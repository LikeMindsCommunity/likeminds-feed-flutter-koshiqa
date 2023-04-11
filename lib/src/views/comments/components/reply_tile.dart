import 'package:feed_sx/src/views/comments/components/dropdown_options_reply.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/packages/expandable_text/expandable_text.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/utils.dart';
import 'package:feed_sx/src/views/comments/blocs/toggle_like_comment/toggle_like_comment_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReplyTile extends StatefulWidget {
  final String postId;
  final String commentId;
  final CommentReply reply;
  final User user;
  final Function() refresh;

  const ReplyTile({
    super.key,
    required this.reply,
    required this.user,
    required this.postId,
    required this.commentId,
    required this.refresh,
  });

  @override
  State<ReplyTile> createState() => _ReplyTileState();
}

class _ReplyTileState extends State<ReplyTile> {
  late final ToggleLikeCommentBloc _toggleLikeCommentBloc;
  late final CommentReply reply;
  late final User user;
  late final String postId;
  late final String commentId;
  late final Function() refresh;
  int? likeCount;

  bool isLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reply = widget.reply;
    user = widget.user;
    postId = widget.postId;
    isLiked = reply.isLiked;
    commentId = widget.commentId;
    refresh = widget.refresh;
    likeCount = widget.reply.likesCount;
    FeedApi feedApi = locator<LikeMindsService>().getFeedApi();
    _toggleLikeCommentBloc = ToggleLikeCommentBloc(feedApi: feedApi);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: kWhiteColor),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              DropdownOptionsReply(
                menuItems: reply.menuItems,
                replyDetails: reply,
                postId: postId,
                commentId: widget.commentId,
                refresh: refresh,
              ),
            ],
          ),
          kVerticalPaddingSmall,
          ExpandableText(
            widget.reply.text,
            expandText: 'show more',
          ),
          kVerticalPaddingLarge,
          Row(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isLiked) {
                          likeCount = likeCount! - 1;
                        } else {
                          likeCount = likeCount! + 1;
                        }
                        isLiked = !isLiked;
                      });

                      _toggleLikeCommentBloc.add(ToggleLikeComment(
                        toggleLikeCommentRequest:
                            (ToggleLikeCommentRequestBuilder()
                                  ..commentId(reply.id)
                                  ..postId(postId))
                                .build(),
                      ));
                    },
                    child: Builder(builder: ((context) {
                      return isLiked
                          ? SvgPicture.asset(
                              kAssetLikeFilledIcon,
                              // color: kPrimaryColor,
                              height: 17,
                            )
                          : SvgPicture.asset(
                              kAssetLikeIcon,
                              color: kGrey3Color,
                              height: 13,
                            );
                    })),
                  ),
                  kHorizontalPaddingSmall,
                  Text(
                    likeCount! > 0
                        ? "$likeCount ${likeCount! > 1 ? 'Likes' : 'Like'}"
                        : '',
                    style: const TextStyle(
                        fontSize: kFontSmallMed, color: kGrey3Color),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                reply.createdAt.timeAgo(),
                style: const TextStyle(
                    fontSize: kFontSmallMed, color: kGrey3Color),
              ),
            ],
          )
        ],
      ),
    );
  }
}
