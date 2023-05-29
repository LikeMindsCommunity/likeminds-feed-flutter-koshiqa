import 'package:collection/collection.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/expandable_text/expandable_text.dart';
import 'package:feed_sx/src/utils/constants/string_constants.dart';
import 'package:feed_sx/src/utils/local_preference/user_local_preference.dart';
import 'package:feed_sx/src/views/comments/blocs/add_comment_reply/add_comment_reply_bloc.dart';
import 'package:feed_sx/src/views/comments/components/dropdown_options_comment.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/utils.dart';
import 'package:feed_sx/src/views/comments/blocs/comment_replies/comment_replies_bloc.dart';
import 'package:feed_sx/src/views/comments/blocs/toggle_like_comment/toggle_like_comment_bloc.dart';
import 'package:feed_sx/src/views/comments/components/reply_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';

class CommentTile extends StatefulWidget {
  final String postId;
  final Reply reply;
  final User user;
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
  ValueNotifier<bool> rebuildLikeButton = ValueNotifier(false);
  ValueNotifier<bool> rebuildReplyList = ValueNotifier(false);
  Reply? reply;
  late final User user;
  late final String postId;
  Function()? refresh;
  int? likeCount;
  bool isLiked = false, _replyVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
    postId = widget.postId;
    _toggleLikeCommentBloc = ToggleLikeCommentBloc();
    _commentRepliesBloc = CommentRepliesBloc();
  }

  @override
  void dispose() {
    _toggleLikeCommentBloc.close();
    _commentRepliesBloc.close();
    rebuildLikeButton.dispose();
    rebuildReplyList.dispose();
    super.dispose();
  }

  void initialiseReply() {
    reply = widget.reply;
    isLiked = reply!.isLiked;
    likeCount = reply!.likesCount;
    refresh = widget.refresh;
  }

  int page = 1;

  // List<CommentReply> replies = [];

  bool checkCommentRights() {
    final MemberStateResponse memberStateResponse =
        UserLocalPreference.instance.fetchMemberRights();
    if (memberStateResponse.state == 1) {
      return true;
    }
    bool memberRights = UserLocalPreference.instance.fetchMemberRight(10);
    return memberRights;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AddCommentReplyBloc addCommentReplyBloc =
        BlocProvider.of<AddCommentReplyBloc>(context);
    initialiseReply();

    return Container(
      decoration: const BoxDecoration(color: kWhiteColor),
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ProfilePicture(user: user, size: 32),
                ),
                kHorizontalPaddingLarge,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: 240,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpandableText(
                        reply!.text,
                        expandText: 'show more',
                      ),
                    ),
                    // SizedBox(
                    //   height: 4,
                    // ),
                    // SizedBox(
                    //   child: ExpandableText(
                    //     reply!.text,
                    //     expandText: 'show more',
                    //   ),
                    // ),
                  ],
                ),
                const Spacer(),
                DropdownOptionsComments(
                  menuItems: reply!.menuItems,
                  replyDetails: reply!,
                  postId: postId,
                  refresh: refresh!,
                ),
              ],
            ),
          ),
          // kVerticalPaddingMedium,
          kVerticalPaddingLarge,
          Row(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
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
                                    ..postId(postId))
                                  .build()));
                    },
                    child: ValueListenableBuilder(
                        valueListenable: rebuildLikeButton,
                        builder: (context, _, __) {
                          return isLiked
                              ? SvgPicture.asset(
                                  kAssetLikeFilledIcon,
                                  // color: kPrimaryColor,
                                  height: 18,
                                )
                              : SvgPicture.asset(
                                  kAssetLikeIcon,
                                  color: kGrey3Color,
                                  height: 14,
                                );
                        }),
                  ),
                  kHorizontalPaddingSmall,
                  ValueListenableBuilder(
                      valueListenable: rebuildLikeButton,
                      builder: (context, _, __) {
                        return GestureDetector(
                          onTap: () {
                            locator<NavigationService>()
                                .navigateTo(LikesScreen.route,
                                    arguments: LikesScreenArguments(
                                      postId: postId,
                                      commentId: reply!.id,
                                      isCommentLikes: true,
                                    ));
                          },
                          child: Text(
                            likeCount! > 0
                                ? "$likeCount ${likeCount! > 1 ? kStringLikes : kStringLike}"
                                : '',
                            style: const TextStyle(
                              fontSize: kFontSmallMed,
                              color: kGrey3Color,
                            ),
                          ),
                        );
                      }),
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
                onTap: checkCommentRights()
                    ? () {
                        widget.onReply(reply!.id, user.name);
                      }
                    : () => toast("You do not have permission to comment"),
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
                          _replyVisible = false;
                          page = 1;
                          rebuildReplyList.value = !rebuildReplyList.value;
                          return;
                        } else {
                          _commentRepliesBloc.add(GetCommentReplies(
                              commentDetailRequest: (GetCommentRequestBuilder()
                                    ..commentId(reply!.id)
                                    ..page(1)
                                    ..postId(postId))
                                  .build(),
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
                  fontSize: kFontSmallMed,
                  color: kGrey3Color,
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
              valueListenable: rebuildReplyList,
              builder: (context, _, __) {
                return BlocConsumer(
                  bloc: _commentRepliesBloc,
                  builder: ((context, state) {
                    if (state is CommentRepliesLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }
                    if (state is CommentRepliesLoaded ||
                        state is PaginatedCommentRepliesLoading) {
                      // replies.addAll(state.commentDetails.postReplies.replies);
                      List<CommentReply> replies = [];
                      Map<String, User> users = {};
                      if (state is CommentRepliesLoaded) {
                        replies = state.commentDetails.postReplies!.replies;
                        users = state.commentDetails.users!;
                      } else if (state is PaginatedCommentRepliesLoading) {
                        replies = state.prevCommentDetails.postReplies!.replies;
                        users = state.prevCommentDetails.users!;
                      }
                      List<Widget> repliesW = [];
                      if (_replyVisible) {
                        repliesW = replies.mapIndexed((index, element) {
                          return ReplyTile(
                            // key: Key(element.id),
                            reply: element,
                            user: users[element.userId]!,
                            postId: postId,
                            refresh: refresh!,
                            commentId: reply!.id,
                          );
                        }).toList();
                      } else {
                        repliesW = [];
                      }

                      if (replies.length % 10 == 0 &&
                          _replyVisible &&
                          replies.length != reply!.repliesCount) {
                        repliesW = [
                          ...repliesW,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  page++;
                                  _commentRepliesBloc.add(GetCommentReplies(
                                      commentDetailRequest:
                                          (GetCommentRequestBuilder()
                                                ..commentId(reply!.id)
                                                ..page(page)
                                                ..postId(postId))
                                              .build(),
                                      forLoadMore: true));
                                },
                                child: const Text(
                                  'View more replies',
                                  style: TextStyle(
                                    color: kBlueGreyColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                ' ${replies.length} of ${widget.reply.repliesCount}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: kGrey3Color,
                                ),
                              )
                            ],
                          )
                        ];
                        // replies.add();
                      }
                      return BlocConsumer<AddCommentReplyBloc,
                          AddCommentReplyState>(
                        bloc: addCommentReplyBloc,
                        listener: (context, state) {
                          if (state is AddCommentReplySuccess) {
                            replies.insert(0, state.addCommentResponse.reply!);

                            repliesW = replies.mapIndexed((index, element) {
                              return ReplyTile(
                                // key: Key(element.id),
                                reply: element,
                                user: users[element.userId]!,
                                postId: postId,
                                refresh: refresh!,
                                commentId: reply!.id,
                              );
                            }).toList();
                            if (replies.isNotEmpty &&
                                replies.length % 10 == 0 &&
                                _replyVisible &&
                                replies.length != reply!.repliesCount) {
                              repliesW = [
                                ...repliesW,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        page++;
                                        _commentRepliesBloc.add(
                                            GetCommentReplies(
                                                commentDetailRequest:
                                                    (GetCommentRequestBuilder()
                                                          ..commentId(reply!.id)
                                                          ..page(page)
                                                          ..postId(postId))
                                                        .build(),
                                                forLoadMore: true));
                                      },
                                      child: const Text(
                                        'View more replies',
                                        style: TextStyle(
                                          color: kBlueGreyColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' ${replies.length} of ${widget.reply.repliesCount}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: kGrey3Color,
                                      ),
                                    )
                                  ],
                                )
                              ];
                              // replies.add();
                            }
                          }
                          if (state is EditReplySuccess) {
                            int index = replies.indexWhere((element) =>
                                element.id ==
                                state.editCommentReplyResponse.reply!.id);
                            if (index != -1) {
                              replies[index] =
                                  state.editCommentReplyResponse.reply!;

                              if (_replyVisible) {
                                repliesW = replies.mapIndexed((index, element) {
                                  return ReplyTile(
                                    // key: Key(element.id),
                                    reply: element,
                                    user: users[element.userId]!,
                                    postId: postId,
                                    refresh: refresh!,
                                    commentId: reply!.id,
                                  );
                                }).toList();
                              } else {
                                repliesW = [];
                              }

                              if (replies.isNotEmpty &&
                                  replies.length % 10 == 0 &&
                                  _replyVisible &&
                                  replies.length != reply!.repliesCount) {
                                repliesW = [
                                  ...repliesW,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          page++;
                                          _commentRepliesBloc.add(
                                              GetCommentReplies(
                                                  commentDetailRequest:
                                                      (GetCommentRequestBuilder()
                                                            ..commentId(
                                                                reply!.id)
                                                            ..page(page)
                                                            ..postId(postId))
                                                          .build(),
                                                  forLoadMore: true));
                                        },
                                        child: const Text(
                                          'View more replies',
                                          style: TextStyle(
                                            color: kBlueGreyColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ' ${replies.length} of ${widget.reply.repliesCount}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: kGrey3Color,
                                        ),
                                      )
                                    ],
                                  )
                                ];
                                // replies.add();
                              }
                            }
                          }
                          if (state is CommentReplyDeleted) {
                            int index = replies.indexWhere(
                                (element) => element.id == state.replyId);
                            if (index != -1) {
                              replies.removeAt(index);

                              if (_replyVisible) {
                                repliesW = replies.mapIndexed((index, element) {
                                  return ReplyTile(
                                    // key: Key(element.id),
                                    reply: element,
                                    user: users[element.userId]!,
                                    postId: postId,
                                    refresh: refresh!,
                                    commentId: reply!.id,
                                  );
                                }).toList();
                              } else {
                                repliesW = [];
                              }

                              if (replies.isNotEmpty &&
                                  replies.length % 10 == 0 &&
                                  _replyVisible &&
                                  replies.length != reply!.repliesCount) {
                                repliesW = [
                                  ...repliesW,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          page++;
                                          _commentRepliesBloc.add(
                                              GetCommentReplies(
                                                  commentDetailRequest:
                                                      (GetCommentRequestBuilder()
                                                            ..commentId(
                                                                reply!.id)
                                                            ..page(page)
                                                            ..postId(postId))
                                                          .build(),
                                                  forLoadMore: true));
                                        },
                                        child: const Text(
                                          'View more replies',
                                          style: TextStyle(
                                            color: kBlueGreyColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ' ${replies.length} of ${widget.reply.repliesCount}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: kGrey3Color,
                                        ),
                                      )
                                    ],
                                  )
                                ];
                                // replies.add();
                              }
                            }
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            padding: const EdgeInsets.only(
                              left: 48,
                              top: 8,
                              bottom: 0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: repliesW,
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  }),
                  listener: (BuildContext context, state) {},
                );
              }),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
