import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/simple_bloc_observer.dart';
import 'package:feed_sx/src/views/likes/bloc/likes_bloc.dart';
import 'package:feed_sx/src/views/likes/likes_helper.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class LikesScreen extends StatefulWidget {
  static const String route = "/likes_screen";
  final String postId;
  final bool isCommentLikes;
  final String? commentId;

  const LikesScreen({
    super.key,
    this.isCommentLikes = false,
    required this.postId,
    this.commentId,
  });

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  LikesBloc? _likesBloc;
  int _offset = 1;
  Map<String, User> userData = {};

  final PagingController<int, Like> _pagingControllerLikes =
      PagingController(firstPageKey: 1);

  final PagingController<int, CommentLike> _pagingControllerCommentLikes =
      PagingController(firstPageKey: 1);

  void _addPaginationListener() {
    if (widget.isCommentLikes) {
      _pagingControllerCommentLikes.addPageRequestListener(
        (pageKey) {
          _likesBloc!.add(
            GetCommentLikes(
              offset: pageKey,
              pageSize: 10,
              postId: widget.postId,
              commentId: widget.commentId!,
            ),
          );
        },
      );
    } else {
      _pagingControllerLikes.addPageRequestListener(
        (pageKey) {
          _likesBloc!.add(
            GetLikes(
              postId: widget.postId,
              offset: pageKey,
              pageSize: 10,
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    _likesBloc = LikesBloc();
    _addPaginationListener();
    if (widget.isCommentLikes && widget.commentId != null) {
      _likesBloc!.add(
        GetCommentLikes(
          offset: 1,
          pageSize: 10,
          postId: widget.postId,
          commentId: widget.commentId!,
        ),
      );
    } else {
      _likesBloc!.add(
        GetLikes(
          offset: 1,
          pageSize: 10,
          postId: widget.postId,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pagingControllerLikes.dispose();
    _pagingControllerCommentLikes.dispose();
    _likesBloc?.close();
    super.dispose();
  }

  void updatePagingControllers(Object? state) {
    if (state is LikesLoaded) {
      _offset += 1;
      if (state.response.likes!.length < 10) {
        userData.addAll(state.response.users ?? {});
        _pagingControllerLikes.appendLastPage(state.response.likes ?? []);
      } else {
        userData.addAll(state.response.users ?? {});
        _pagingControllerLikes.appendPage(state.response.likes!, _offset);
      }
    }
    if (state is CommentLikesLoaded) {
      _offset += 1;
      if (state.response.commentLikes!.length < 10) {
        userData.addAll(state.response.users ?? {});
        _pagingControllerCommentLikes
            .appendLastPage(state.response.commentLikes ?? []);
      } else {
        userData.addAll(state.response.users ?? {});
        _pagingControllerCommentLikes.appendPage(
            state.response.commentLikes!, _offset);
      }
    }
  }

  // Analytics event logging for Like Screen
  void logLikeListEvent(totalLikes) {
    LMAnalytics.get().track(
      AnalyticsKeys.likeListOpen,
      {
        "post_id": widget.postId,
        "total_likes": totalLikes,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        locator<NavigationService>().goBack();
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: BlocConsumer(
            bloc: _likesBloc,
            buildWhen: (previous, current) {
              if (current is LikesPaginationLoading &&
                  (previous is LikesLoaded || previous is CommentLikesLoaded)) {
                return false;
              }
              return true;
            },
            listener: (context, state) => updatePagingControllers(state),
            builder: (context, state) {
              if (state is LikesLoading) {
                return getLikesLoadingView();
              } else if (state is LikesError) {
                return getLikesErrorView(state.message);
              } else if (state is LikesLoaded) {
                if (!widget.isCommentLikes) {
                  logLikeListEvent(state.response.totalCount);
                }
                return getLikesLoadedView(state: state);
              } else if (state is CommentLikesLoaded) {
                return getCommentLikesLoadedView(commentState: state);
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }

  Widget getAppBar(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [
          kHorizontalPaddingSmall,
          IconButton(
            onPressed: () {
              locator<NavigationService>().goBack();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          kHorizontalPaddingSmall,
          Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget getCommentLikesLoadedView({CommentLikesLoaded? commentState}) {
    return Column(
      children: [
        const SizedBox(height: 64),
        getAppBar(
          "${commentState!.response.totalCount} Likes",
        ),
        kVerticalPaddingLarge,
        Expanded(
          child: PagedListView(
            padding: EdgeInsets.zero,
            pagingController: _pagingControllerCommentLikes,
            builderDelegate: PagedChildBuilderDelegate<CommentLike>(
              noMoreItemsIndicatorBuilder: (context) => const SizedBox(
                height: 20,
              ),
              noItemsFoundIndicatorBuilder: (context) => const Scaffold(
                backgroundColor: kWhiteColor,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("No likes to show",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 12),
                      Text("Be the first one to like this post",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: kGrey2Color)),
                      SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
              itemBuilder: (context, item, index) =>
                  LikesTile(user: userData[item.userId]),
            ),
          ),
        )
      ],
    );
  }

  Widget getLikesLoadedView({
    LikesLoaded? state,
  }) {
    return Column(
      children: [
        const SizedBox(height: 64),
        getAppBar(
          "${state!.response.totalCount} Likes",
        ),
        kVerticalPaddingLarge,
        Expanded(
          child: PagedListView<int, Like>(
            padding: EdgeInsets.zero,
            pagingController: _pagingControllerLikes,
            builderDelegate: PagedChildBuilderDelegate<Like>(
              noMoreItemsIndicatorBuilder: (context) => const SizedBox(
                height: 20,
              ),
              noItemsFoundIndicatorBuilder: (context) => const Scaffold(
                backgroundColor: kWhiteColor,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("No likes to show",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 12),
                      Text("Be the first one to like this post",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: kGrey2Color)),
                      SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
              itemBuilder: (context, item, index) =>
                  LikesTile(user: userData[item.userId]),
            ),
          ),
        )
      ],
    );
  }

  Widget getLikesErrorView(String message) {
    return Center(
      child: Text(message),
    );
  }

  Widget getLikesLoadingView() {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 120),
        itemCount: 5,
        itemBuilder: (context, index) => getLikesTileShimmer());
  }
}

class LikesTile extends StatelessWidget {
  final User? user;
  const LikesTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return user!.isDeleted != null && user!.isDeleted!
          ? const DeletedLikesTile()
          : Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: Row(
                children: [
                  ProfilePicture(user: user!),
                  kHorizontalPaddingSmall,
                  kHorizontalPaddingMedium,
                  Text(
                    user!.name,
                    style: const TextStyle(
                      fontSize: kFontMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            );
    } else {
      return const Center(
        child: Text("No likes yet"),
      );
    }
  }
}

class DeletedLikesTile extends StatelessWidget {
  const DeletedLikesTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27), color: kGreyBGColor),
            height: 54,
            width: 54,
          ),
          kHorizontalPaddingSmall,
          kHorizontalPaddingMedium,
          const Text(
            'Deleted User',
            style: TextStyle(fontSize: kFontMedium, color: kGrey3Color),
          )
        ],
      ),
    );
  }
}
