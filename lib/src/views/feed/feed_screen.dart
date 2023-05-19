// ignore_for_file: prefer_const_constructors

import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/utils/simple_bloc_observer.dart';
import 'package:feed_sx/src/views/feed/blocs/universal_feed/universal_feed_bloc.dart';
import 'package:feed_sx/src/views/feed/components/custom_feed_app_bar.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:likeminds_feed/likeminds_feed.dart';

const List<int> DUMMY_FEEDROOMS = [72200, 72232, 72233];

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final UniversalFeedBloc _feedBloc;
  static const _pageSize = 20;

  final PagingController<int, Post> _pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    _feedBloc = UniversalFeedBloc();
  }

  _addPaginationListener() {
    _pagingController.addPageRequestListener((pageKey) {
      _feedBloc.add(GetUniversalFeed(offset: pageKey, forLoadMore: true));
    });
  }

  refresh() => () {
        setState(() {});
      };

  int _page = 0;

  @override
  Widget build(BuildContext context) {
    _addPaginationListener();
    _feedBloc.add(GetUniversalFeed(offset: 1, forLoadMore: false));
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomFeedAppBar(),
      body: BlocConsumer(
        bloc: _feedBloc,
        listener: (context, state) {
          if (state is UniversalFeedLoaded) {
            _page++;
            if (state.feed.posts.length < 10) {
              _pagingController.appendLastPage(state.feed.posts);
            } else {
              _pagingController.appendPage(state.feed.posts, _page);
            }
          }
        },
        builder: ((context, state) {
          if (state is UniversalFeedLoaded) {
            UniversalFeedResponse feedResponse = state.feed;
            return PagedListView<int, Post>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Post>(
                itemBuilder: (context, item, index) => PostWidget(
                  feedRoomId: DUMMY_FEEDROOMS.first,
                  postDetails: item,
                  user: feedResponse.users[item.userId]!,
                  refresh: refresh(),
                ),
              ),
            );
          }
          return Center(child: const Loader());
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // MaterialPageRoute route =
          //     MaterialPageRoute(builder: (context) => NewPostScreen());
          // Navigator.push(context, route);
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
