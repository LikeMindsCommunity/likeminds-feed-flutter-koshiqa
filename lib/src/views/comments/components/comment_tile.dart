import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:feed_sx/src/packages/expandable_text/expandable_text.dart';
import 'package:feed_sx/src/utils/constants/string_constants.dart';
import 'package:feed_sx/src/views/comments/components/dropdown_options_comment.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:feed_sx/src/widgets/text_with_links.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/utils.dart';
import 'package:feed_sx/src/views/comments/blocs/comment_replies/comment_replies_bloc.dart';
import 'package:feed_sx/src/views/comments/blocs/toggle_like_comment/toggle_like_comment_bloc.dart';
import 'package:feed_sx/src/views/comments/components/reply_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentTile extends StatefulWidget {
  final String postId;
  final Reply reply;
  final PostUser user;
  final Function() refresh;
  final Function(String commentId, String username) onReply;
  const CommentTile({
    super.key,
    required this.reply,
    required this.user,
    required this.postId,
    required this.onReply,
    required this.refresh,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile>
    with AutomaticKeepAliveClientMixin {
  late final ToggleLikeCommentBloc _toggleLikeCommentBloc;
  late final CommentRepliesBloc _commentRepliesBloc;
  late final Reply reply;
  late final PostUser user;
  late final String postId;
  late final Function() refresh;
  int? likeCount;
  bool isLiked = false, _replyVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reply = widget.reply;
    user = widget.user;
    postId = widget.postId;
    isLiked = reply.isLiked;
    likeCount = reply.likesCount;
    refresh = widget.refresh;
    FeedApi feedApi = locator<LikeMindsService>().getFeedApi();
    _toggleLikeCommentBloc = ToggleLikeCommentBloc(feedApi: feedApi);
    _commentRepliesBloc = CommentRepliesBloc(feedApi: feedApi);
  }

  int page = 1;

  // List<CommentReply> replies = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: const BoxDecoration(color: kWhiteColor),
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfilePicture(user: user, size: 28),
              kHorizontalPaddingMedium,
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              DropdownOptionsComments(
                menuItems: reply.menuItems,
                replyDetails: reply,
                postId: postId,
                refresh: refresh,
              ),
            ],
          ),
          kVerticalPaddingMedium,
          ExpandableText(reply.text,
              expandText: 'show more', collapseText: 'show less'),
          // TextWithLinks(
          //   text: reply.text,
          //   // expandText: 'show more',
          //   // collapseText: 'show less',
          // ),
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
                          toggleLikeCommentRequest: ToggleLikeCommentRequest(
                        commentId: reply.id,
                        postId: postId,
                      )));
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
                        ? "$likeCount ${likeCount! > 1 ? kStringLikes : kStringLike}"
                        : kStringLike,
                    style: const TextStyle(
                      fontSize: kFontSmallMed,
                      color: kGrey3Color,
                    ),
                  ),
                ],
              ),
              kHorizontalPaddingMedium,
              const Text(
                '|',
                style: TextStyle(
                  fontSize: kFontSmallMed,
                  color: kGrey3Color,
                ),
              ),
              kHorizontalPaddingMedium,
              GestureDetector(
                onTap: () => widget.onReply(reply.id, user.name),
                child: const Text(
                  'Reply',
                  style: TextStyle(
                    fontSize: kFontSmallMed,
                    color: kGrey3Color,
                  ),
                ),
              ),
              kHorizontalPaddingMedium,
              const Text(
                '·',
                style: TextStyle(
                  fontSize: kFontSmallMed,
                  color: kGrey3Color,
                ),
              ),
              kHorizontalPaddingMedium,
              widget.reply.repliesCount > 0
                  ? GestureDetector(
                      onTap: () {
                        if (_replyVisible) {
                          setState(() {
                            _replyVisible = false;
                          });
                          return;
                        } else {
                          _commentRepliesBloc.add(GetCommentReplies(
                              commentDetailRequest: CommentDetailRequest(
                                  commentId: reply.id, page: 1, postId: postId),
                              forLoadMore: false));
                          _replyVisible = true;
                        }
                      },
                      child: Text(
                        widget.reply.repliesCount > 1
                            ? "${widget.reply.repliesCount}  replies"
                            : "${widget.reply.repliesCount}  reply",
                        style: const TextStyle(
                          fontSize: kFontSmallMed,
                          color: kPrimaryColor,
                        ),
                      ),
                    )
                  : Container(),
              const Spacer(),
              Text(
                reply.createdAt.timeAgo(),
                style: const TextStyle(
                  fontSize: kFontSmallMed,
                  color: kGrey3Color,
                ),
              ),
            ],
          ),
          BlocConsumer(
            bloc: _commentRepliesBloc,
            builder: ((context, state) {
              if (state is CommentRepliesLoading) {
                return const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                );
              }
              if (state is CommentRepliesLoaded ||
                  state is PaginatedCommentRepliesLoading) {
                // replies.addAll(state.commentDetails.postReplies.replies);
                List<CommentReply> replies = [];
                Map<String, PostUser> users = {};
                if (state is CommentRepliesLoaded) {
                  replies = state.commentDetails.postReplies.replies;
                  users = state.commentDetails.users;
                } else if (state is PaginatedCommentRepliesLoading) {
                  replies = state.prevCommentDetails.postReplies.replies;
                  users = state.prevCommentDetails.users;
                }
                List<Widget> repliesW = [];
                if (_replyVisible) {
                  repliesW = replies.mapIndexed((index, element) {
                    return ReplyTile(
                      // key: Key(element.id),
                      reply: element,
                      user: users[element.userId]!,
                      postId: postId,
                      refresh: refresh,
                      commentId: reply.id,
                    );
                  }).toList();
                } else {
                  repliesW = [];
                }

                if (replies.length % 10 == 0) {
                  repliesW = [
                    ...repliesW,
                    TextButton(
                        onPressed: () {
                          page++;
                          _commentRepliesBloc.add(GetCommentReplies(
                              commentDetailRequest: CommentDetailRequest(
                                  commentId: reply.id,
                                  page: page,
                                  postId: postId),
                              forLoadMore: true));
                        },
                        child: const Text(
                          'View more replies',
                          style: TextStyle(color: kBlueGreyColor, fontSize: 14),
                        ))
                  ];
                  // replies.add();
                }
                return Container(
                  padding: const EdgeInsets.only(left: 48),
                  // width: MediaQuery.of(context).size.width,
                  // constraints: BoxConstraints(
                  //     maxHeight: MediaQuery.of(context).size.height * 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: repliesW,
                  ),
                );
              }
              return Container();
            }),
            listener: (BuildContext context, state) {},
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
