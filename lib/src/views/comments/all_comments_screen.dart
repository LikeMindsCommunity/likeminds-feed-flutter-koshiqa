// ignore_for_file: prefer_const_constructors

import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/comments/blocs/add_comment/add_comment_bloc.dart';
import 'package:feed_sx/src/views/comments/blocs/add_comment_reply/add_comment_reply_bloc.dart';
import 'package:feed_sx/src/views/comments/blocs/all_comments/all_comments_bloc.dart';
import 'package:feed_sx/src/views/comments/components/comment_tile.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/widgets/general_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AllCommentsScreen extends StatefulWidget {
  final String postId;
  static const String route = "/all_comments_screen";
  const AllCommentsScreen({super.key, required this.postId});

  @override
  State<AllCommentsScreen> createState() => _AllCommentsScreenState();
}

class _AllCommentsScreenState extends State<AllCommentsScreen> {
  late final AllCommentsBloc _allCommentsBloc;
  late final AddCommentBloc _addCommentBloc;
  late final AddCommentReplyBloc _addCommentReplyBloc;
  final TextEditingController _commentController = TextEditingController();
  String commentVal = "";
  final PagingController<int, Reply> _pagingController =
      PagingController(firstPageKey: 1);
  String? selectedCommentId;
  String? selectedUsername;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FeedApi feedApi = locator<LikeMindsService>().getFeedApi();
    _allCommentsBloc = AllCommentsBloc(feedApi: feedApi);
    _allCommentsBloc.add(GetAllComments(
        postDetailRequest: PostDetailRequest(postId: widget.postId, page: 1),
        forLoadMore: false));
    _addCommentBloc = AddCommentBloc(feedApi: feedApi);
    _addCommentReplyBloc = AddCommentReplyBloc(feedApi: feedApi);
    _addPaginationListener();
  }

  int _page = 1;
  _addPaginationListener() {
    _pagingController.addPageRequestListener((pageKey) {
      print(pageKey.toString() + " : Page Key");
      _allCommentsBloc.add(GetAllComments(
          postDetailRequest:
              PostDetailRequest(postId: widget.postId, page: pageKey),
          forLoadMore: true));
    });
  }

  selectCommentToReply(String commentId, String username) {
    setState(() {
      selectedCommentId = commentId;
      selectedUsername = username;
    });
  }

  deselectCommentToReply() {
    setState(() {
      selectedCommentId = null;
      selectedUsername = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: kWhiteColor, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              selectedCommentId != null
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            "Replying to",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: kHeadingColor),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            selectedUsername!,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryColor),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              deselectCommentToReply();
                            },
                            icon: Icon(
                              Icons.close,
                              color: kGreyColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              TextField(
                controller: _commentController,
                onChanged: (val) {
                  setState(() {
                    commentVal = val;
                  });
                },
                decoration: InputDecoration(
                  suffixIconConstraints: BoxConstraints(
                    maxHeight: 50,
                    maxWidth: 50,
                  ),
                  suffixIcon: selectedCommentId == null
                      ? BlocConsumer<AddCommentBloc, AddCommentState>(
                          bloc: _addCommentBloc,
                          listener: ((context, state) {
                            if (state is AddCommentSuccess) {
                              _commentController.clear();
                              _pagingController.refresh();
                              _page = 1;

                              // _allCommentsBloc.add(GetAllComments(
                              //     postDetailRequest: PostDetailRequest(
                              //         postId: widget.postId, page: 1),
                              //     forLoadMore: false));
                            }
                          }),
                          builder: (context, state) {
                            if (state is AddCommentLoading)
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            return IconButton(
                              onPressed: commentVal.isEmpty
                                  ? null
                                  : () {
                                      _addCommentBloc.add(AddComment(
                                          addCommentRequest: AddCommentRequest(
                                              postId: widget.postId,
                                              text: commentVal)));
                                    },
                              icon: Icon(
                                Icons.send,
                                color: commentVal.isNotEmpty
                                    ? kPrimaryColor
                                    : kGreyColor,
                              ),
                            );
                          },
                        )
                      : BlocConsumer<AddCommentReplyBloc, AddCommentReplyState>(
                          bloc: _addCommentReplyBloc,
                          listener: ((context, state) {
                            if (state is AddCommentReplySuccess) {
                              _commentController.clear();
                              _pagingController.refresh();
                              selectedCommentId = null;
                              selectedUsername = null;
                              _page = 1;

                              deselectCommentToReply();
                            }
                          }),
                          builder: (context, state) {
                            if (state is AddCommentReplyLoading)
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            return IconButton(
                              onPressed: commentVal.isEmpty
                                  ? null
                                  : () {
                                      _addCommentReplyBloc.add(AddCommentReply(
                                          addCommentRequest:
                                              AddCommentReplyRequest(
                                                  postId: widget.postId,
                                                  text: commentVal,
                                                  commentId:
                                                      selectedCommentId!)));
                                      selectedCommentId = null;
                                      selectedUsername = null;
                                      // deselectCommentToReply();
                                    },
                              icon: Icon(
                                Icons.send,
                                color: commentVal.isNotEmpty
                                    ? kPrimaryColor
                                    : kGreyColor,
                              ),
                            );
                          },
                        ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  hintText: 'Write a comment',
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: kBackgroundColor,
      appBar: GeneralAppBar(
        autoImplyEnd: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Post',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: kHeadingColor),
            ),
            // const Text(
            //   '12 Comments',
            //   style: TextStyle(
            //       fontSize: 13,
            //       fontWeight: FontWeight.w500,
            //       color: kHeadingColor),
            // ),
          ],
        ),
      ),
      body: BlocConsumer<AllCommentsBloc, AllCommentsState>(
        listener: (context, state) {
          if (state is AllCommentsLoaded) {
            _page++;
            if (state.postDetails.postReplies.replies.length < 10) {
              _pagingController
                  .appendLastPage(state.postDetails.postReplies.replies);
            } else {
              _pagingController.appendPage(
                  state.postDetails.postReplies.replies, _page);
            }
          }
        },
        bloc: _allCommentsBloc,
        builder: (context, state) {
          if (state is AllCommentsLoaded ||
              state is PaginatedAllCommentsLoading) {
            late PostDetailResponse postDetailResponse;
            if (state is AllCommentsLoaded) {
              print("AllCommentsLoaded" + state.toString());
              postDetailResponse = state.postDetails;
            } else {
              print("PaginatedAllCommentsLoading" + state.toString());
              postDetailResponse =
                  (state as PaginatedAllCommentsLoading).prevPostDetails;
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PostWidget(
                    postDetails: Post(
                      id: postDetailResponse.postReplies.id,
                      text: postDetailResponse.postReplies.text,
                      attachments: postDetailResponse.postReplies.attachments,
                      communityId: postDetailResponse.postReplies.communityId,
                      isPinned: postDetailResponse.postReplies.isPinned,
                      userId: postDetailResponse.postReplies.userId,
                      likeCount: postDetailResponse.postReplies.likeCount,
                      isSaved: postDetailResponse.postReplies.isSaved,
                      menuItems: postDetailResponse.postReplies.menuItems,
                      createdAt: postDetailResponse.postReplies.createdAt,
                      updatedAt: postDetailResponse.postReplies.updatedAt,
                      isLiked: postDetailResponse.postReplies.isLiked,
                      commentCount:
                          postDetailResponse.postReplies.commentsCount,
                    ),
                    user: postDetailResponse
                        .users[postDetailResponse.postReplies.userId]!,
                    postType: 0,
                  ),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 12)),
                PagedSliverList(
                  // addAutomaticKeepAlives: true,
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Reply>(
                      itemBuilder: (context, item, index) {
                    return CommentTile(
                      key: ValueKey(item.id),
                      reply: item,
                      user: postDetailResponse.users[item.userId]!,
                      postId: postDetailResponse.postReplies.id,
                      onReply: selectCommentToReply,
                    );
                  }),
                ),
                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (context, index) {
                //       return CommentTile(
                //         reply: postDetailResponse.postReplies.replies[index],
                //         user: postDetailResponse.users[postDetailResponse
                //             .postReplies.replies[index].userId]!,
                //         postId: postDetailResponse.postReplies.id,
                //       );
                //     },
                //     childCount: postDetailResponse.postReplies.replies.length,
                //   ),
                // ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
          // if (state is AllCommentsLoading) {

          // }
        },
      ),
    );
  }
}
