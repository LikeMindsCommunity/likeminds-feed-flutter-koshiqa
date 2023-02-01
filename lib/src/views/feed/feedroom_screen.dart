// ignore_for_file: prefer_const_constructors

import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/data/local_db/local_db_impl.dart';
import 'package:feed_sx/src/data/models/branding/branding.dart';
import 'package:feed_sx/src/data/repositories/branding/branding_repository.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/sdk/branding_sdk.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/simple_bloc_observer.dart';
import 'package:feed_sx/src/theme.dart';
import 'package:feed_sx/src/views/feed/blocs/feedroom/feedroom_bloc.dart';
import 'package:feed_sx/src/views/feed/components/custom_feed_app_bar.dart';
import 'package:feed_sx/src/views/feed/components/feedroom_tile.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/views/new_post/new_post_screen.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:feed_sdk/feed_sdk.dart';

const List<int> DUMMY_FEEDROOMS = [72200, 72232, 72233];

class FeedRoomScreen extends StatefulWidget {
  final bool isCm;
  const FeedRoomScreen({
    super.key,
    required this.isCm,
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

  refresh() => () {
        setState(() {});
      };

  int _page = 0;
  bool _addButton = false;

  @override
  Widget build(BuildContext context) {
    final isCm = widget.isCm;
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
              title: Text(feedRoom.chatroom!["title"]),
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
                      return PostWidget(
                          postType: 1,
                          postDetails: item,
                          user: feedResponse.users[item.userId]!,
                          refresh: refresh);
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => NewPostScreen());
                Navigator.push(context, route);
              },
              child: const Icon(Icons.add),
              backgroundColor: kPrimaryColor,
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
                                feedRoomId: item.chatroom!["id"],
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
        }
        return Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(child: const Loader()));
      }),
    );
  }
}
