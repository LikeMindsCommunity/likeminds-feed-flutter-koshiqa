// ignore_for_file: prefer_const_constructors

import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/views/feed/components/new_post_button.dart';
import 'package:flutter_svg/svg.dart';
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

  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    _feedBloc = FeedRoomBloc();
  }

  @override
  Widget build(BuildContext context) {
    final isCm = widget.isCm;
    final user = widget.user;
    if (isCm) {
      _feedBloc.add(GetFeedRoomList());
    } else {
      _feedBloc.add(GetFeedRoom(feedRoomId: DUMMY_FEEDROOM));
    }
    return BlocConsumer(
      bloc: _feedBloc,
      listener: (context, state) {},
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
          // When the state is FeedRoomLoaded, we return the FeedRoomFeed
          return FeedRoomFeed(
            isCm: isCm,
            feedBloc: _feedBloc,
            feedResponse: state.feed,
            user: user,
            feedRoom: state.feedRoom,
          );
        } else if (state is FeedRoomListLoaded) {
          // When the state is FeedRoomListLoaded, we return the FeedRoomList
          return FeedRoomList(
            feedBloc: _feedBloc,
            feedRooms: state.feedList,
            size: state.size,
          );
        } else if (state is FeedRoomEmpty) {
          return FeedRoomEmptyView(
            isCm: isCm,
            feedBloc: _feedBloc,
            user: user,
            feedRoom: state.feedRoom,
          );
        } else if (state is FeedRoomError) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(
              child: Text(state.message),
            ),
          );
        } else if (state is FeedRoomListEmpty) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(
              child: Text("No feedrooms found"),
            ),
          );
        } else if (state is FeedRoomLoading || state is FeedRoomListLoading) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(
              child: Loader(),
            ),
          );
        }

        return Container(
          color: Colors.red,
        );
      }),
    );
  }
}

class FeedRoomEmptyView extends StatelessWidget {
  const FeedRoomEmptyView(
      {Key? key,
      required this.isCm,
      required FeedRoomBloc feedBloc,
      required this.user,
      required this.feedRoom})
      : _feedBloc = feedBloc,
        super(key: key);

  final bool isCm;
  final FeedRoomBloc _feedBloc;
  final User user;
  final FeedRoom feedRoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: isCm
            ? BackButton(
                color: Colors.white,
                onPressed: () {
                  _feedBloc.add(GetFeedRoomList());
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
                    .then((value) =>
                        _feedBloc.add(GetFeedRoom(feedRoomId: feedRoom.id)));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FeedRoomList extends StatelessWidget {
  final int size;
  final List<FeedRoom> feedRooms;

  const FeedRoomList({
    Key? key,
    required FeedRoomBloc feedBloc,
    required this.feedRooms,
    required this.size,
  })  : _feedBloc = feedBloc,
        super(key: key);

  final FeedRoomBloc _feedBloc;

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: size,
              itemBuilder: (BuildContext context, int index) {
                final item = feedRooms[index];
                return FeedRoomTile(
                    item: item,
                    onTap: () {
                      _feedBloc.add(
                        GetFeedRoom(
                          feedRoomId: item.id,
                          // feedRoomResponse: state.feedRooms,
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeedRoomFeed extends StatelessWidget {
  const FeedRoomFeed({
    Key? key,
    required this.isCm,
    required FeedRoomBloc feedBloc,
    required this.feedResponse,
    required this.user,
    required this.feedRoom,
  })  : _feedBloc = feedBloc,
        super(key: key);

  final bool isCm;
  final FeedRoomBloc _feedBloc;
  final FeedRoom feedRoom;
  final GetFeedOfFeedRoomResponse feedResponse;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: isCm
            ? BackButton(
                color: Colors.white,
                onPressed: () {
                  _feedBloc.add(GetFeedRoomList());
                },
              )
            : null,
        title: Text(feedRoom.title),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              itemCount: feedResponse.posts!.length,
              itemBuilder: (BuildContext context, int index) {
                final item = feedResponse.posts![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AllCommentsScreen.route,
                            arguments: AllCommentsScreenArguments(post: item))
                        .then((value) => {
                              _feedBloc.add(GetFeedRoom(
                                feedRoomId: feedRoom.id,
                              ))
                            });
                  },
                  child: PostWidget(
                    postType: 1,
                    postDetails: item,
                    user: feedResponse.users[item.userId]!,
                    refresh: () {
                      _feedBloc.add(GetFeedRoom(
                        feedRoomId: feedRoom.id,
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: NewPostButton(
        onTap: () {
          locator<NavigationService>().navigateTo(
            NewPostScreen.route,
            arguments: NewPostScreenArguments(
              feedroomId: feedRoom.id,
              user: user,
            ),
          );
        },
      ),
    );
  }
}
