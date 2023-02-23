// ignore_for_file: prefer_const_constructors

import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/views/feed/components/new_post_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/simple_bloc_observer.dart';
import 'package:feed_sx/src/views/feed/blocs/feedroom/feedroom_bloc.dart';
import 'package:feed_sx/src/views/feed/components/feedroom_tile.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//const List<int> DUMMY_FEEDROOMS = [72345, 72346, 72347];
const List<int> DUMMY_FEEDROOMS = [72200, 72232, 72233];

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
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, GetFeedRoomResponse>
      _pagingControllerFeedRoomList = PagingController(firstPageKey: 1);

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
          feedRoomId: DUMMY_FEEDROOMS.first,
          offset: pageKey,
          forLoadMore: false));
    });
    _pagingControllerFeedRoomList.addPageRequestListener((pageKey) {
      _feedBloc.add(GetFeedRoomList(
          feedRoomIds: DUMMY_FEEDROOMS, offset: pageKey, forLoadMore: false));
    });
  }

  refresh() => () {
        setState(() {});
      };

  int _pageFeedRoom = 0;
  int _pageFeedRoomList = 0;
  bool _addButton = false;

  @override
  Widget build(BuildContext context) {
    isCm = widget.isCm;
    final user = widget.user;
    if (isCm!) {
      _feedBloc.add(GetFeedRoomList(
          feedRoomIds: DUMMY_FEEDROOMS, offset: 1, forLoadMore: false));
    } else {
      _feedBloc.add(GetFeedRoom(
          feedRoomId: DUMMY_FEEDROOMS.first, offset: 1, forLoadMore: false));
    }
    return BlocConsumer(
      bloc: _feedBloc,
      buildWhen: (prev, curr) {
        if ((prev is FeedRoomLoaded && curr is FeedRoomLoading) ||
            (prev is FeedRoomListLoaded && curr is FeedRoomListLoading)) {
          return false;
        }
        return true;
      },
      listener: (context, state) {
        if (state is FeedRoomLoaded) {
          _pageFeedRoom++;
          if (state.feed.posts!.length < 10) {
            _pagingController.appendLastPage(state.feed.posts ?? []);
          } else {
            _pagingController.appendPage(state.feed.posts ?? [], _pageFeedRoom);
          }
        } else if (state is FeedRoomListLoaded) {
          _pageFeedRoomList++;
          if (state.feedRooms.length < 10) {
            _pagingControllerFeedRoomList.appendLastPage(state.feedRooms);
          } else {
            _pagingControllerFeedRoomList.appendPage(
                state.feedRooms, _pageFeedRoomList);
          }
        }
      },
      builder: ((context, state) {
        if (state is FeedRoomLoaded) {
          LMAnalytics.get().logEvent(
            AnalyticsKeys.feedOpened,
            {
              "feed_type": {
                "feedroom": {
                  "id": state.feedRoom.chatroom!.id,
                }
              }
            },
          );
          GetFeedOfFeedRoomResponse feedResponse = state.feed;
          GetFeedRoomResponse feedRoom = state.feedRoom;
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              leading: isCm!
                  ? BackButton(
                      color: Colors.white,
                      onPressed: () {
                        _pagingController.nextPageKey = _pageFeedRoom = 1;
                        _pagingController.itemList!.clear();
                        _pagingControllerFeedRoomList.itemList!.clear();
                        _feedBloc.add(GetFeedRoomList(
                            feedRoomIds: DUMMY_FEEDROOMS,
                            offset: 1,
                            forLoadMore: true));
                      },
                    )
                  : null,
              title: Text(feedRoom.chatroom!.title),
              backgroundColor: kPrimaryColor,
            ),
            body: Column(
              children: [
                SizedBox(height: 18),
                Expanded(
                  child: PagedListView<int, Post>(
                    pagingController: _pagingController,
                    scrollController: scrollController,
                    builderDelegate: PagedChildBuilderDelegate<Post>(
                        itemBuilder: (context, item, index) {
                      return PostWidget(
                        postType: 1,
                        postDetails: item,
                        user: feedResponse.users[item.userId]!,
                        refresh: refresh,
                      );
                    }),
                  ),
                )
              ],
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: NewPostButton(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => NewPostScreen(
                          feedRoomId: feedRoom.chatroom!.id,
                          user: user,
                        ));
                Navigator.push(context, route);
              },
            ),
          );
        } else if (state is FeedRoomListLoaded) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              title: Text("Choose FeedRoom"),
              backgroundColor: kPrimaryColor,
            ),
            body: Column(
              children: [
                SizedBox(height: 18),
                Expanded(
                  child: PagedListView<int, GetFeedRoomResponse>(
                    pagingController: _pagingControllerFeedRoomList,
                    scrollController: scrollController,
                    builderDelegate:
                        PagedChildBuilderDelegate<GetFeedRoomResponse>(
                            itemBuilder: (context, item, index) {
                      return FeedRoomTile(
                          item: item,
                          onTap: () {
                            _feedBloc.add(GetFeedRoom(
                                feedRoomId: item.chatroom!.id,
                                feedRoomResponse: item,
                                offset: 1,
                                forLoadMore: true));
                          });
                    }),
                  ),
                )
              ],
            ),
          );
        } else if (state is FeedRoomError) {
          return Scaffold(
              backgroundColor: kBackgroundColor,
              body: Center(child: Text(state.message)));
        } else if (state is FeedRoomListEmpty) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(
              child: Text("No feedrooms found"),
            ),
          );
        } else if (state is FeedRoomEmpty) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              leading: isCm!
                  ? BackButton(
                      color: Colors.white,
                      onPressed: () {
                        _pagingController.nextPageKey = _pageFeedRoom = 1;
                        _pagingController.itemList!.clear();
                        _pagingControllerFeedRoomList.itemList!.clear();
                        _feedBloc.add(GetFeedRoomList(
                            feedRoomIds: DUMMY_FEEDROOMS,
                            offset: 1,
                            forLoadMore: true));
                      },
                    )
                  : null,
              title: Text(state.feedRoom.chatroom!.title),
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
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => NewPostScreen(
                                feedRoomId: state.feedRoom.chatroom!.id,
                                user: user,
                              ));
                      Navigator.push(context, route);
                    },
                  ),
                ],
              ),
            ),
          );
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
