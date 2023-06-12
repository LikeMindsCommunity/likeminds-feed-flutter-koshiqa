import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/views/comments/components/dropdown_options_reply.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/expandable_text/expandable_text.dart';
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
  ValueNotifier<bool> rebuildLikeButton = ValueNotifier(false);
  CommentReply? reply;
  late final User user;
  String? postId;
  String? commentId;
  Function()? refresh;
  int? likeCount;

  bool isLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;

    likeCount = widget.reply.likesCount;
    _toggleLikeCommentBloc = ToggleLikeCommentBloc();
  }

  @override
  void dispose() {
    _toggleLikeCommentBloc.close();
    rebuildLikeButton.dispose();
    super.dispose();
  }

  void initialise() {
    reply = widget.reply;
    postId = widget.postId;
    isLiked = reply!.isLiked;
    commentId = widget.commentId;
    refresh = widget.refresh;
  }

  @override
  Widget build(BuildContext context) {
    initialise();
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
                menuItems: reply!.menuItems,
                replyDetails: reply!,
                postId: postId!,
                commentId: widget.commentId,
                refresh: refresh!,
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
                  ValueListenableBuilder(
                      valueListenable: rebuildLikeButton,
                      builder: (context, _, __) {
                        return GestureDetector(
                          onTap: () {
                            print('like button tapped');
                            if (isLiked) {
                              likeCount = likeCount! - 1;
                              widget.reply.likesCount -= 1;
                            } else {
                              likeCount = likeCount! + 1;
                              widget.reply.likesCount += 1;
                            }
                            isLiked = !isLiked;
                            widget.reply.isLiked = isLiked;

                            rebuildLikeButton.value = !rebuildLikeButton.value;

                            _toggleLikeCommentBloc.add(ToggleLikeComment(
                              toggleLikeCommentRequest:
                                  (ToggleLikeCommentRequestBuilder()
                                        ..commentId(reply!.id)
                                        ..postId(postId!))
                                      .build(),
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            child: isLiked
                                ? SvgPicture.asset(
                                    kAssetLikeFilledIcon,
                                    // color: kPrimaryColor,
                                    height: 17,
                                  )
                                : SvgPicture.asset(
                                    kAssetLikeIcon,
                                    color: kGrey3Color,
                                    height: 13,
                                  ),
                          ),
                        );
                      }),
                  kHorizontalPaddingSmall,
                  ValueListenableBuilder(
                    valueListenable: rebuildLikeButton,
                    builder: (context, _, __) {
                      return GestureDetector(
                        onTap: () {
                          locator<NavigationService>()
                              .navigateTo(LikesScreen.route,
                                  arguments: LikesScreenArguments(
                                    postId: postId!,
                                    commentId: reply!.id,
                                    isCommentLikes: true,
                                  ));
                        },
                        child: Text(
                          likeCount! > 0
                              ? "$likeCount ${likeCount! > 1 ? 'Likes' : 'Like'}"
                              : '',
                          style: const TextStyle(
                            fontSize: kFontSmallMed,
                            color: kGrey3Color,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              reply!.isEdited != null && reply!.isEdited!
                  ? const Row(
                      children: [
                        Text(
                          "Edited",
                          style: TextStyle(
                            fontSize: kFontSmallMed,
                            color: kGrey3Color,
                          ),
                        ),
                        kHorizontalPaddingMedium,
                        Text(
                          '·',
                          style: TextStyle(
                            fontSize: kFontSmallMed,
                            color: kGrey3Color,
                          ),
                        ),
                        kHorizontalPaddingMedium,
                      ],
                    )
                  : const SizedBox(),
              Text(
                reply!.createdAt.timeAgo(),
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
