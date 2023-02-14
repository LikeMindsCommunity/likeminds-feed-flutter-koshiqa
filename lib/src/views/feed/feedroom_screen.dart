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

const List<int> DUMMY_FEEDROOMS = [72345, 72346, 72347];
// const List<int> DUMMY_FEEDROOMS = [72200, 72232, 72233];

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

  int _page = 0;
  bool _addButton = false;

  @override
  Widget build(BuildContext context) {
    final isCm = widget.isCm;
    final user = widget.user;
    if (isCm) {
      _feedBloc.add(GetFeedRoomList(feedRoomIds: DUMMY_FEEDROOMS));
    } else {
      _feedBloc.add(GetFeedRoom(feedRoomId: DUMMY_FEEDROOMS.first));
    }
    return BlocConsumer(
      bloc: _feedBloc,
      listener: (context, state) {},
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
              leading: isCm
                  ? BackButton(
                      color: Colors.white,
                      onPressed: () {
                        _feedBloc
                            .add(GetFeedRoomList(feedRoomIds: DUMMY_FEEDROOMS));
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
                  child: ListView.builder(
                    itemCount: feedResponse.posts!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = feedResponse.posts![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AllCommentsScreen.route,
                                  arguments:
                                      AllCommentsScreenArguments(post: item))
                              .then((value) => {
                                    _feedBloc.add(GetFeedRoom(
                                        feedRoomId: feedRoom.chatroom!.id))
                                  });
                        },
                        child: PostWidget(
                          postType: 1,
                          postDetails: item,
                          user: feedResponse.users[item.userId]!,
                          refresh: () {
                            _feedBloc.add(
                                GetFeedRoom(feedRoomId: feedRoom.chatroom!.id));
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
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => NewPostScreen(
                          feedRoomId: feedRoom.chatroom!.id,
                          user: user,
                        ));
                Navigator.push(context, route).then((value) => {
                      _feedBloc
                          .add(GetFeedRoom(feedRoomId: feedRoom.chatroom!.id))
                    });
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
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.feedRooms.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = state.feedRooms[index];
                      return FeedRoomTile(
                          item: item,
                          onTap: () {
                            _feedBloc.add(
                              GetFeedRoom(
                                feedRoomId: item.chatroom!.id,
                                feedRoomResponse: item,
                              ),
                            );
                          });
                    },
                  ),
                ),
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
              leading: isCm
                  ? BackButton(
                      color: Colors.white,
                      onPressed: () {
                        _feedBloc
                            .add(GetFeedRoomList(feedRoomIds: DUMMY_FEEDROOMS));
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
                      Navigator.push(context, route).then((value) => {
                            _feedBloc.add(GetFeedRoom(
                                feedRoomId: state.feedRoom.chatroom!.id))
                          });
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
