// ignore_for_file: prefer_const_constructors

import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/views/feed/components/new_post_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/simple_bloc_observer.dart';
import 'package:feed_sx/src/views/feed/blocs/feedroom/feedroom_bloc.dart';
import 'package:feed_sx/src/views/feed/components/feedroom_tile.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//const List<int> DUMMY_FEEDROOMS = [72345, 72346, 72347];
//const List<int> DUMMY_FEEDROOMS = [72200, 72232, 72233];
const int DUMMY_FEEDROOM = 72200;

class FeedRoomScreen extends StatefulWidget {
  final bool isCm;
  final User user;
  const FeedRoomScreen({
    super.key,
    required this.isCm,
    required this.user,
  });

  @override
  State<FeedRoomScreen> createState() => _FeedRoomScreenState();
}

class _FeedRoomScreenState extends State<FeedRoomScreen> {
  late final FeedRoomBloc _feedBloc;
  bool? isCm;

  // to control paging on FeedRoom View
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  // to control paging on FeedRoomList View
  final PagingController<int, FeedRoom> _pagingControllerFeedRoomList =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _addPaginationListener();
    Bloc.observer = SimpleBlocObserver();
    _feedBloc = FeedRoomBloc();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _pagingControllerFeedRoomList.dispose();
    super.dispose();
  }

  _addPaginationListener() {
    _pagingController.addPageRequestListener((pageKey) {
      _feedBloc.add(GetFeedRoom(
          feedRoomId: DUMMY_FEEDROOM,
          offset: pageKey,
          isPaginationLoading: true));
    });
    _pagingControllerFeedRoomList.addPageRequestListener((pageKey) {
      _feedBloc
          .add(GetFeedRoomList(offset: pageKey, isPaginationLoading: true));
    });
  }

  refresh() {
    _pagingController.refresh();
    clearPagingController();
  }

  int _pageFeedRoom = 0; // current index of FeedRoom
  int _pageFeedRoomList = 0; // current index of FeedRoomList

  void updatePagingControllers(Object? state) {
    if (state is FeedRoomLoaded) {
      _pageFeedRoom++;
      if (state.feed.posts!.length < 10) {
        _pagingController.appendLastPage(state.feed.posts ?? []);
      } else {
        _pagingController.appendPage(state.feed.posts ?? [], _pageFeedRoom);
      }
    } else if (state is FeedRoomListLoaded) {
      _pageFeedRoomList++;
      if (state.size < 10) {
        _pagingControllerFeedRoomList.appendLastPage(state.feedList);
      } else {
        _pagingControllerFeedRoomList.appendPage(
            state.feedList, _pageFeedRoomList);
      }
    }
  }

  void clearPagingController() {
    /* Clearing paging controller while changing the
     event to prevent duplication of list */
    _pagingController.nextPageKey = _pageFeedRoom = 1;
    _pagingController.itemList!.clear();
    _pagingControllerFeedRoomList.itemList!.clear();
  }

  @override
  Widget build(BuildContext context) {
    isCm = widget.isCm;
    final user = widget.user;
    if (isCm!) {
      _feedBloc.add(GetFeedRoomList(offset: 1));
    } else {
      _feedBloc.add(GetFeedRoom(feedRoomId: DUMMY_FEEDROOM, offset: 1));
    }
    return BlocConsumer(
      bloc: _feedBloc,
      buildWhen: (prev, curr) {
        // Prevents changin the state while paginating the feed
        if ((prev is FeedRoomLoaded && curr is PaginationLoading) ||
            (prev is FeedRoomListLoaded && curr is PaginationLoading)) {
          return false;
        }
        return true;
      },
      listener: (context, state) => updatePagingControllers(state),
      builder: ((context, state) {
        if (state is FeedRoomLoaded) {
          // Log the event in the analytics
          LMAnalytics.get().logEvent(
            AnalyticsKeys.feedOpened,
            {
              "feed_type": {
                "feedroom": {
                  "id": state.feedRoom.id,
                }
              }
            },
          );
          return FeedRoomView(
              isCm: isCm!,
              feedResponse: state.feed,
              onPressedBack: clearPagingController,
              feedRoomBloc: _feedBloc,
              feedRoom: state.feedRoom,
              feedRoomPagingController: _pagingController,
              user: user,
              onRefresh: refresh);
        } else if (state is FeedRoomListLoaded) {
          return FeedRoomListView(
              pagingControllerFeedRoomList: _pagingControllerFeedRoomList,
              feedRoomBloc: _feedBloc);
        } else if (state is FeedRoomError) {
          return FeedRoomErrorView(message: state.message);
        } else if (state is FeedRoomListEmpty) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(
              child: Text("No feedrooms found"),
            ),
          );
        } else if (state is FeedRoomEmpty) {
          return FeedRoomEmptyView(
              isCm: isCm!,
              onPressedBack: clearPagingController,
              feedBloc: _feedBloc,
              onRefresh: refresh,
              user: user,
              feedRoom: state.feedRoom);
        }

        return Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(
              child: const Loader(),
            ));
      }),
    );
  }
}

class FeedRoomErrorView extends StatelessWidget {
  final String message;
  const FeedRoomErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor, body: Center(child: Text(message)));
  }
}

class FeedRoomEmptyView extends StatelessWidget {
  const FeedRoomEmptyView(
      {Key? key,
      required this.isCm,
      required this.onPressedBack,
      required this.onRefresh,
      required FeedRoomBloc feedBloc,
      required this.user,
      required this.feedRoom})
      : _feedBloc = feedBloc,
        super(key: key);

  final bool isCm;
  final FeedRoomBloc _feedBloc;
  final User user;
  final FeedRoom feedRoom;
  final VoidCallback onRefresh;
  final VoidCallback onPressedBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: isCm
            ? BackButton(
                color: Colors.white,
                onPressed: () {
                  onPressedBack();
                  _feedBloc.add(GetFeedRoomList(offset: 1));
                },
              )
            : null,
        title: Text(feedRoom.title),
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              kAssetPostsIcon,
              color: kGrey3Color,
            ),
            SizedBox(height: 12),
            Text("No posts to show",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 12),
            Text("Be the first one to post here",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: kGrey2Color)),
            SizedBox(height: 28),
            NewPostButton(
              onTap: () {
                locator<NavigationService>()
                    .navigateTo(
                  NewPostScreen.route,
                  arguments: NewPostScreenArguments(
                    feedroomId: feedRoom.id,
                    user: user,
                  ),
                )
                    .then((result) {
                  if (result != null && result['isBack']) {
                    onRefresh();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FeedRoomView extends StatelessWidget {
  final bool isCm;
  final FeedRoom feedRoom;
  final User user;
  final FeedRoomBloc feedRoomBloc;
  final VoidCallback onPressedBack;
  final GetFeedOfFeedRoomResponse feedResponse;
  final PagingController<int, Post> feedRoomPagingController;
  final VoidCallback onRefresh;

  const FeedRoomView({
    super.key,
    required this.isCm,
    required this.feedResponse,
    required this.onPressedBack,
    required this.feedRoomBloc,
    required this.feedRoom,
    required this.feedRoomPagingController,
    required this.user,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: isCm
            ? BackButton(
                color: Colors.white,
                onPressed: () {
                  onPressedBack();
                  feedRoomBloc.add(GetFeedRoomList(offset: 1));
                },
              )
            : null,
        title: Text(feedRoom.title),
        backgroundColor: kPrimaryColor,
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            feedRoomBloc.add(GetFeedRoom(feedRoomId: feedRoom.id, offset: 0));
            onRefresh();
          },
          child: Column(
            children: [
              SizedBox(height: 18),
              Expanded(
                child: PagedListView<int, Post>(
                  pagingController: feedRoomPagingController,
                  builderDelegate: PagedChildBuilderDelegate<Post>(
                      noItemsFoundIndicatorBuilder: (context) => Scaffold(
                          backgroundColor: kBackgroundColor,
                          body: Center(
                            child: const Loader(),
                          )),
                      itemBuilder: (context, item, index) {
                        return PostWidget(
                          postType: 1,
                          postDetails: item,
                          user: feedResponse.users[item.userId]!,
                          refresh: onRefresh,
                        );
                      }),
                ),
              )
            ],
          )),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: NewPostButton(
        onTap: () {
          locator<NavigationService>()
              .navigateTo(
            NewPostScreen.route,
            arguments: NewPostScreenArguments(
              feedroomId: feedRoom.id,
              user: user,
            ),
          )
              .then((result) {
            if (result != null && result['isBack']) {
              onRefresh();
            }
          });
        },
      ),
    );
  }
}

class FeedRoomListView extends StatelessWidget {
  final FeedRoomBloc feedRoomBloc;
  final PagingController<int, FeedRoom> pagingControllerFeedRoomList;
  const FeedRoomListView(
      {super.key,
      required this.pagingControllerFeedRoomList,
      required this.feedRoomBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("Choose FeedRoom"),
        backgroundColor: kPrimaryColor,
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            feedRoomBloc.add(GetFeedRoomList(offset: 0));
            pagingControllerFeedRoomList.itemList!.clear();
          },
          child: Column(
            children: [
              SizedBox(height: 18),
              Expanded(
                child: PagedListView<int, FeedRoom>(
                  pagingController: pagingControllerFeedRoomList,
                  builderDelegate: PagedChildBuilderDelegate<FeedRoom>(
                      noItemsFoundIndicatorBuilder: (context) => Scaffold(
                          backgroundColor: kBackgroundColor,
                          body: Center(
                            child: const Loader(),
                          )),
                      itemBuilder: (context, item, index) {
                        return FeedRoomTile(
                            item: item,
                            onTap: () {
                              feedRoomBloc.add(GetFeedRoom(
                                  feedRoomId: item.id,
                                  feedRoomResponse: item,
                                  offset: 1));
                            });
                      }),
                ),
              )
            ],
          )),
    );
  }
}
