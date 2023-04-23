import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';
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
import 'package:overlay_support/overlay_support.dart';

class AllCommentsScreen extends StatefulWidget {
  final String postId;
  final int feedRoomId;
  final bool fromComment;
  static const String route = "/all_comments_screen";

  const AllCommentsScreen({
    super.key,
    required this.postId,
    required this.feedRoomId,
    required this.fromComment,
  });

  @override
  State<AllCommentsScreen> createState() => _AllCommentsScreenState();
}

class _AllCommentsScreenState extends State<AllCommentsScreen> {
  late final AllCommentsBloc _allCommentsBloc;
  late final AddCommentBloc _addCommentBloc;
  late final AddCommentReplyBloc _addCommentReplyBloc;
  final FocusNode focusNode = FocusNode();
  TextEditingController? _commentController;
  ValueNotifier<bool> rebuildButton = ValueNotifier(false);
  ValueNotifier<bool> rebuildPostWidget = ValueNotifier(false);
  ValueNotifier<bool> rebuildReplyWidget = ValueNotifier(false);
  final PagingController<int, Reply> _pagingController =
      PagingController(firstPageKey: 1);
  Post? postData;

  List<UserTag> userTags = [];
  String? result = '';
  bool isEditing = false;
  bool isReplying = false;

  String? selectedCommentId;
  String? selectedUsername;

  @override
  void initState() {
    super.initState();
    updatePostDetails(context);
    _commentController = TextEditingController();
    if (_commentController != null) {
      _commentController!.addListener(
        () {
          if (_commentController!.text.isEmpty) {
            _commentController!.clear();
          }
        },
      );
    }
    _allCommentsBloc = AllCommentsBloc();
    _allCommentsBloc.add(GetAllComments(
        postDetailRequest: (PostDetailRequestBuilder()
              ..postId(widget.postId)
              ..page(1))
            .build(),
        forLoadMore: false));
    _addCommentBloc = AddCommentBloc();
    _addCommentReplyBloc = AddCommentReplyBloc();
    _addPaginationListener();
    if(widget.fromComment && focusNode.canRequestFocus){
      focusNode.requestFocus();
    }
  }

  int _page = 1;

  _addPaginationListener() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        _allCommentsBloc.add(
          GetAllComments(
            postDetailRequest: (PostDetailRequestBuilder()
                  ..postId(widget.postId)
                  ..page(pageKey))
                .build(),
            forLoadMore: true,
          ),
        );
      },
    );
  }

  selectCommentToEdit(String commentId, String username) {
    selectedCommentId = commentId;
    isEditing = true;
    selectedUsername = username;
    isReplying = false;
    rebuildReplyWidget.value = !rebuildReplyWidget.value;
  }

  deselectCommentToEdit() {
    selectedCommentId = null;
    selectedUsername = null;
    isEditing = false;
    rebuildReplyWidget.value = !rebuildReplyWidget.value;
  }

  selectCommentToReply(String commentId, String username) {
    selectedCommentId = commentId;
    selectedUsername = username;
    isReplying = true;
    isEditing = false;
    if(focusNode.canRequestFocus){
      focusNode.requestFocus();
    }
    rebuildReplyWidget.value = !rebuildReplyWidget.value;
  }

  deselectCommentToReply() {
    selectedCommentId = null;
    selectedUsername = null;
    isReplying = false;
    rebuildReplyWidget.value = !rebuildReplyWidget.value;
  }

  Future updatePostDetails(BuildContext context) async {
    final GetPostResponse postDetails =
        await locator<LikeMindsService>().getPost(
      (GetPostRequestBuilder()
            ..postId(widget.postId)
            ..page(1)
            ..pageSize(10))
          .build(),
    );
    if (postDetails.success) {
      postData = postDetails.post;
      rebuildPostWidget.value = !rebuildPostWidget.value;
    } else {
      toast(
        postDetails.errorMessage ?? 'An error occured',
        duration: Toast.LENGTH_LONG,
      );
    }
  }

  void increaseCommentCount() {
    postData!.commentCount = postData!.commentCount + 1;
    rebuildPostWidget.value = !rebuildPostWidget.value;
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
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  kVerticalPaddingMedium,
                  ValueListenableBuilder(
                      valueListenable: rebuildReplyWidget,
                      builder: (context, _, __) {
                        return selectedCommentId != null
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Replying to",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: kHeadingColor),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      selectedUsername!,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: kPrimaryColor),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        deselectCommentToReply();
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: kGreyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox();
                      }),
                  TaggingAheadTextField(
                    feedroomId: widget.feedRoomId,
                    focusNode: focusNode,
                    isDown: false,
                    controller: _commentController,
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
                      suffixIconConstraints: const BoxConstraints(
                        maxHeight: 50,
                        maxWidth: 50,
                      ),
                      suffixIcon: selectedCommentId == null
                          ? BlocConsumer<AddCommentBloc, AddCommentState>(
                              bloc: _addCommentBloc,
                              listener: ((context, state) {
                                if (state is AddCommentSuccess) {
                                  _commentController!.clear();
                                  //updatePostDetails(context);
                                  increaseCommentCount();
                                }
                              }),
                              builder: (context, state) {
                                if (state is AddCommentLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
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
                                                        (AddCommentRequestBuilder()
                                                              ..postId(
                                                                  widget.postId)
                                                              ..text(
                                                                  commentText))
                                                            .build(),
                                                  ),
                                                );
                                                closeOnScreenKeyboard();
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
                                  //updatePostDetails(context);
                                }
                              }),
                              builder: (context, state) {
                                if (state is AddCommentReplyLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
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
                                        onPressed: _commentController!
                                                .text.isEmpty
                                            ? null
                                            : () {
                                                final commentText =
                                                    TaggingHelper.encodeString(
                                                        _commentController!
                                                            .text,
                                                        userTags);
                                                _addCommentReplyBloc.add(
                                                    AddCommentReply(
                                                        addCommentRequest:
                                                            (AddCommentReplyRequestBuilder()
                                                                  ..postId(widget
                                                                      .postId)
                                                                  ..text(
                                                                      commentText)
                                                                  ..commentId(
                                                                      selectedCommentId!))
                                                                .build()));
                                                selectedCommentId = null;
                                                selectedUsername = null;
                                                closeOnScreenKeyboard();
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
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
                      ' ${postData == null ? '--' : postData!.commentCount} ${postData == null ? 'Comment' : postData!.commentCount > 1 ? 'Comments' : 'Comment'}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: kHeadingColor),
                    ),
                  ],
                );
              },
            ),
            elevation: 2,
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
                return RefreshIndicator(
                  onRefresh: () async {
                    await updatePostDetails(context);
                  },
                  child: CustomScrollView(
                    slivers: [
                      const SliverPadding(padding: EdgeInsets.only(top: 16)),
                      SliverToBoxAdapter(
                        child: ValueListenableBuilder(
                          valueListenable: rebuildPostWidget,
                          builder: (context, _, __) {
                            if (postData == null) {
                              return const PostShimmer();
                            }
                            return PostWidget(
                              postDetails: postData!,
                              feedRoomId: widget.feedRoomId,
                              user: postDetailResponse.users[
                                  postDetailResponse.postReplies.userId]!,
                              isFeed: false,
                              refresh: (bool isDeleted) async {
                                if (isDeleted) {
                                  locator<NavigationService>()
                                      .goBack(result: {'isBack': isDeleted});
                                } else {
                                  await updatePostDetails(context);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SliverPadding(padding: EdgeInsets.only(bottom: 12)),
                      SliverToBoxAdapter(
                        child: ValueListenableBuilder(
                          valueListenable: rebuildPostWidget,
                          builder: (context, _, __) {
                            return postData == null
                                ? const SizedBox.shrink()
                                : postData!.commentCount >= 1
                                    ? Container(
                                        color: kWhiteColor,
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 15),
                                        child: Text(
                                          '${postData!.commentCount} ${postData!.commentCount > 1 ? 'Comments' : 'Comment'}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                          },
                        ),
                      ),
                      PagedSliverList(
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<Reply>(
                          noMoreItemsIndicatorBuilder: (context) =>
                              const SizedBox(height: 75),
                          noItemsFoundIndicatorBuilder: (context) => Column(
                            children: const <Widget>[
                              SizedBox(height: 42),
                              Text(
                                'No comment found',
                                style: TextStyle(
                                  fontSize: kFontMedium,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Be the first one to comment',
                                style: TextStyle(
                                  fontSize: kFontSmall,
                                ),
                              ),
                              SizedBox(height: 180),
                            ],
                          ),
                          itemBuilder: (context, item, index) {
                            return CommentTile(
                              key: ValueKey(item.id),
                              reply: item,
                              user: postDetailResponse.users[item.userId]!,
                              postId: postDetailResponse.postReplies.id,
                              onReply: selectCommentToReply,
                              refresh: () {
                                _pagingController.refresh();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
              // if (state is AllCommentsLoading) {
              // }
            },
          )),
    );
  }

  void closeOnScreenKeyboard() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }
}
