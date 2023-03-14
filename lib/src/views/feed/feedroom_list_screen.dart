import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/simple_bloc_observer.dart';
import 'package:feed_sx/src/views/feed/blocs/feedroomlist/feedroom_list_bloc.dart';
import 'package:feed_sx/src/views/feed/components/feedroom_tile.dart';
import 'package:feed_sx/src/views/feed/feedroom_screen.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class FeedRoomListScreen extends StatefulWidget {
  final User user;
  const FeedRoomListScreen({super.key, required this.user});

  @override
  State<FeedRoomListScreen> createState() => _FeedRoomListScreenState();
}

class _FeedRoomListScreenState extends State<FeedRoomListScreen> {
  final List<FeedRoom> _feedRoomList = [];
  FeedRoomListBloc? _feedRoomListBloc;
  final PagingController<int, FeedRoom> _pagingControllerFeedRoomList =
      PagingController(firstPageKey: 1);

  _addPaginationListener() {
    _pagingControllerFeedRoomList.addPageRequestListener((pageKey) {
      _feedRoomListBloc!.add(GetFeedRoomList(offset: pageKey));
    });
  }

  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    _feedRoomListBloc = FeedRoomListBloc();
    _addPaginationListener();
    _feedRoomListBloc!.add(const GetFeedRoomList(offset: 1));
  }

  @override
  void dispose() {
    _pagingControllerFeedRoomList.dispose();
    super.dispose();
  }

  void updatePagingControllers(Object? state) {
    if (state is FeedRoomListLoaded) {
      _offset++;
      if (state.size < 10) {
        _pagingControllerFeedRoomList.appendLastPage(state.feedList);
      } else {
        _pagingControllerFeedRoomList.appendPage(state.feedList, _offset);
      }
    }
  }

  void clearPagingController() {
    /* Clearing paging controller while changing the
     event to prevent duplication of list */
    if (_pagingControllerFeedRoomList.itemList != null) {
      _pagingControllerFeedRoomList.itemList!.clear();
    }
    _offset = 1;
  }

  int _offset = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose FeedRoom"),
        backgroundColor: kPrimaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _feedRoomListBloc!.add(const GetFeedRoomList(offset: 1));
          clearPagingController();
        },
        child: BlocConsumer<FeedRoomListBloc, FeedRoomListState>(
          bloc: _feedRoomListBloc,
          listener: (context, state) => updatePagingControllers(state),
          buildWhen: (previous, current) {
            if (current is FeedRoomListLoading && _feedRoomList.isNotEmpty) {
              return false;
            }
            return true;
          },
          builder: ((context, state) {
            if (state is FeedRoomListLoaded) {
              return FeedRoomListView(
                  pagingControllerFeedRoomList: _pagingControllerFeedRoomList,
                  feedRoomBloc: _feedRoomListBloc!,
                  user: widget.user);
            } else if (state is FeedRoomListLoading) {
              return getFeedRoomListLoadingView();
            } else if (state is FeedRoomListError) {
              return getFeedRoomListErrorView(state.message);
            } else if (state is FeedRoomListEmpty) {
              return getFeedRoomListEmptyView();
            }
            return const Scaffold(
                backgroundColor: kBackgroundColor,
                body: Center(
                  child: Loader(),
                ));
          }),
        ),
      ),
    );
  }
}

Widget getFeedRoomListEmptyView() {
  return const Center(
    child: Text("No feedrooms found"),
  );
}

Widget getFeedRoomListErrorView(String message) {
  return Center(
    child: Text(message),
  );
}

Widget getFeedRoomListLoadingView() {
  return const Center(
    child: Loader(),
  );
}

class FeedRoomListView extends StatelessWidget {
  final FeedRoomListBloc feedRoomBloc;
  final PagingController<int, FeedRoom> pagingControllerFeedRoomList;
  final User user;
  const FeedRoomListView(
      {super.key,
      required this.pagingControllerFeedRoomList,
      required this.feedRoomBloc,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        Expanded(
          child: PagedListView<int, FeedRoom>(
            pagingController: pagingControllerFeedRoomList,
            builderDelegate: PagedChildBuilderDelegate<FeedRoom>(
                noMoreItemsIndicatorBuilder: (context) =>
                    const SizedBox(height: 20),
                noItemsFoundIndicatorBuilder: (context) => const Scaffold(
                    backgroundColor: kBackgroundColor,
                    body: Center(
                      child: Loader(),
                    )),
                itemBuilder: (context, item, index) {
                  return FeedRoomTile(
                    item: item,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FeedRoomScreen(
                                isCm: true,
                                user: user,
                                feedRoomId: item.id,
                                feedRoomTitle: item.title,
                              )));
                    },
                  );
                }),
          ),
        )
      ],
    );
  }
}
