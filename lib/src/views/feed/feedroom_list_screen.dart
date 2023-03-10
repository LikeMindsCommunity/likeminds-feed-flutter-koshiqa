import 'package:feed_sx/src/views/feed/blocs/feedroomlist/feedroom_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class FeedRoomListScreen extends StatefulWidget {
  const FeedRoomListScreen({super.key});

  @override
  State<FeedRoomListScreen> createState() => _FeedRoomListScreenState();
}

class _FeedRoomListScreenState extends State<FeedRoomListScreen> {
  final List<FeedRoom> _feedRoomList = [];
  FeedRoomListBloc? _feedRoomListBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _feedRoomListBloc = FeedRoomListBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<FeedRoomListBloc, FeedRoomListState>(
            bloc: _feedRoomListBloc,
            buildWhen: (previous, current) {
              if (current is FeedRoomListLoading && _feedRoomList.isNotEmpty) {
                return false;
              }
              return true;
            },
            builder: (context, feedRoomListState) {
              return Container();
            },
            listener: ((context, state) {})));
  }
}
