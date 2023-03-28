// ignore_for_file: prefer_const_constructors

import 'package:feed_sx/src/views/feed/components/post/post_dialog.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:feed_sx/src/views/tagging/tagging_textfield_ta.dart';
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
  final Post post;
  final int feedRoomId;
  static const String route = "/all_comments_screen";

  const AllCommentsScreen({
    super.key,
    required this.post,
    required this.feedRoomId,
  });

  @override
  State<AllCommentsScreen> createState() => _AllCommentsScreenState();
}

class _AllCommentsScreenState extends State<AllCommentsScreen> {
  late final AllCommentsBloc _allCommentsBloc;
  late final AddCommentBloc _addCommentBloc;
  late final AddCommentReplyBloc _addCommentReplyBloc;

  TextEditingController? _commentController;
  ValueNotifier<bool> rebuildButton = ValueNotifier(false);
  ValueNotifier<bool> rebuildPostWidget = ValueNotifier(false);
  final PagingController<int, Reply> _pagingController =
      PagingController(firstPageKey: 1);
  Post? postData;

  List<UserTag> userTags = [];
  String? result = '';

  String? selectedCommentId;
  String? selectedUsername;

  @override
  void initState() {
    super.initState();
    FeedApi feedApi = locator<LikeMindsService>().getFeedApi();
    _allCommentsBloc = AllCommentsBloc(feedApi: feedApi);
    _allCommentsBloc.add(GetAllComments(
        postDetailRequest: PostDetailRequest(postId: widget.post.id, page: 1),
        forLoadMore: false));
    _addCommentBloc = AddCommentBloc(feedApi: feedApi);
    _addCommentReplyBloc = AddCommentReplyBloc(feedApi: feedApi);
    _addPaginationListener();
    postData = widget.post;
  }

  int _page = 1;
  _addPaginationListener() {
    _pagingController.addPageRequestListener((pageKey) {
      _allCommentsBloc.add(
        GetAllComments(
          postDetailRequest:
              PostDetailRequest(postId: widget.post.id, page: pageKey),
          forLoadMore: true,
        ),
      );
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

  Future updatePostDetails(BuildContext context) async {
    final GetPostResponse postDetails =
        await locator<LikeMindsService>().getPost(
      GetPostRequest(
        postId: postData!.id,
        page: 1,
        pageSize: 10,
      ),
    );
    if (postDetails.success) {
      postData = postDetails.post;
      rebuildPostWidget.value = !rebuildPostWidget.value;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(confirmationToast(
          content: postDetails.errorMessage ?? 'An error occured',
          backgroundColor: kGrey1Color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        locator<NavigationService>().goBack(result: {'isBack': false});
        return Future(() => false);
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          bottomSheet: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
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
                  TaggingAheadTextField(
                    feedroomId: widget.feedRoomId,
                    isDown: false,
                    getController: (controller) {
                      _commentController = controller;
                      if (_commentController != null) {
                        _commentController!.addListener(
                          () {
                            if (_commentController!.text.isEmpty) {
                              _commentController!.clear();
                            }
                          },
                        );
                      }
                    },
                    onTagSelected: (tag) {
                      print(tag);
                      userTags.add(tag);
                    },
                    onChange: (val) {
                      // print(val);
                      // setState(() {
                      result = val;
                      rebuildButton.value = !rebuildButton.value;
                      print(result);
                      // });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIconConstraints: BoxConstraints(
                        maxHeight: 50,
                        maxWidth: 50,
                      ),
                      suffixIcon: selectedCommentId == null
                          ? BlocConsumer<AddCommentBloc, AddCommentState>(
                              bloc: _addCommentBloc,
                              listener: ((context, state) {
                                if (state is AddCommentSuccess) {
                                  _commentController!.clear();
                                  _pagingController.refresh();
                                  _page = 1;
                                  updatePostDetails(context);
                                  closeOnScreenKeyboard();
                                }
                              }),
                              builder: (context, state) {
                                if (state is AddCommentLoading) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                }
                                return ValueListenableBuilder(
                                    valueListenable: rebuildButton,
                                    builder: (context, s, a) {
                                      return IconButton(
                                        onPressed: result!.isEmpty
                                            ? null
                                            : () {
                                                final commentText =
                                                    TaggingHelper.encodeString(
                                                  _commentController!.text,
                                                  userTags,
                                                );
                                                _addCommentBloc.add(
                                                  AddComment(
                                                    addCommentRequest:
                                                        AddCommentRequest(
                                                      postId: widget.post.id,
                                                      text: commentText,
                                                    ),
                                                  ),
                                                );
                                              },
                                        icon: Icon(
                                          Icons.send,
                                          color: result!.isNotEmpty
                                              ? kPrimaryColor
                                              : kGreyColor,
                                        ),
                                      );
                                    });
                              },
                            )
                          : BlocConsumer<AddCommentReplyBloc,
                              AddCommentReplyState>(
                              bloc: _addCommentReplyBloc,
                              listener: ((context, state) {
                                if (state is AddCommentReplySuccess) {
                                  _commentController!.clear();
                                  _pagingController.refresh();
                                  _page = 1;
                                  deselectCommentToReply();
                                  updatePostDetails(context);
                                  closeOnScreenKeyboard();
                                }
                              }),
                              builder: (context, state) {
                                if (state is AddCommentReplyLoading) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                }
                                return ValueListenableBuilder(
                                    valueListenable: rebuildButton,
                                    builder: (
                                      context,
                                      s,
                                      a,
                                    ) {
                                      return IconButton(
                                        onPressed:
                                            _commentController!.text.isEmpty
                                                ? null
                                                : () {
                                                    final commentText =
                                                        TaggingHelper.encodeString(
                                                            _commentController!
                                                                .text,
                                                            userTags);
                                                    _addCommentReplyBloc.add(AddCommentReply(
                                                        addCommentRequest:
                                                            AddCommentReplyRequest(
                                                                postId: widget
                                                                    .post.id,
                                                                text:
                                                                    commentText,
                                                                commentId:
                                                                    selectedCommentId!)));
                                                    selectedCommentId = null;
                                                    selectedUsername = null;

                                                    // deselectCommentToReply();
                                                  },
                                        icon: Icon(
                                          Icons.send,
                                          color: _commentController!
                                                  .text.isNotEmpty
                                              ? kPrimaryColor
                                              : kGreyColor,
                                        ),
                                      );
                                    });
                              },
                            ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      hintText: 'Write a comment',
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: kBackgroundColor,
          appBar: GeneralAppBar(
              backTap: () {
                locator<NavigationService>().goBack(result: {'isBack': false});
              },
              autoImplyEnd: false,
              title: ValueListenableBuilder(
                  valueListenable: rebuildPostWidget,
                  builder: (context, _, __) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Post',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: kHeadingColor),
                        ),
                        Text(
                          '${postData!.commentCount} Comments',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: kHeadingColor),
                        ),
                      ],
                    );
                  }),
              elevation: 5),
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
                  updatePostDetails(context);
                  postDetailResponse = state.postDetails;
                } else {
                  print("PaginatedAllCommentsLoading" + state.toString());
                  updatePostDetails(context);
                  postDetailResponse =
                      (state as PaginatedAllCommentsLoading).prevPostDetails;
                }

                return RefreshIndicator(
                    onRefresh: () async {
                      await updatePostDetails(context);
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                            child: ValueListenableBuilder(
                                valueListenable: rebuildPostWidget,
                                builder: (context, _, __) {
                                  return PostWidget(
                                    postDetails: postData!,
                                    user: postDetailResponse.users[
                                        postDetailResponse.postReplies.userId]!,
                                    postType: 0,
                                    isFeed: false,
                                    refresh: (bool isDeleted) {
                                      locator<NavigationService>().goBack(
                                          result: {'isBack': isDeleted});
                                    },
                                  );
                                })),
                        SliverPadding(padding: EdgeInsets.only(bottom: 12)),
                        postData!.commentCount >= 1
                            ? SliverToBoxAdapter(
                                child: ValueListenableBuilder(
                                    valueListenable: rebuildPostWidget,
                                    builder: (context, _, __) {
                                      return Container(
                                        color: kWhiteColor,
                                        padding:
                                            EdgeInsets.only(left: 15, top: 15),
                                        child: Text(
                                          '${postData!.commentCount} ${postData!.commentCount > 1 ? 'Comments' : 'Comment'}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      );
                                    }))
                            : const SliverToBoxAdapter(
                                child: SizedBox.shrink()),
                        PagedSliverList(
                            // addAutomaticKeepAlives: true,
                            pagingController: _pagingController,
                            builderDelegate: PagedChildBuilderDelegate<Reply>(
                                noMoreItemsIndicatorBuilder: (context) =>
                                    SizedBox(height: 75),
                                noItemsFoundIndicatorBuilder: (context) =>
                                    Column(children: const <Widget>[
                                      SizedBox(height: 40),
                                      Text('No comment found',
                                          style:
                                              TextStyle(fontSize: kFontMedium)),
                                      SizedBox(height: 10),
                                      Text('Be the first one to comment',
                                          style:
                                              TextStyle(fontSize: kFontSmall))
                                    ]),
                                itemBuilder: (context, item, index) {
                                  return CommentTile(
                                    key: ValueKey(item.id),
                                    reply: item,
                                    user:
                                        postDetailResponse.users[item.userId]!,
                                    postId: postDetailResponse.postReplies.id,
                                    onReply: selectCommentToReply,
                                    refresh: () {
                                      _pagingController.refresh();
                                    },
                                  );
                                })),
                      ],
                    ));
              }
              return const Center(child: CircularProgressIndicator());
              // if (state is AllCommentsLoading) {
              // }
            },
          )),
    );
  }
}

void closeOnScreenKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}
