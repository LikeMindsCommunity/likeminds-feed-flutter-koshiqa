import 'package:cached_network_image/cached_network_image.dart';
import 'package:likeminds_feed_flutter_koshiqa/feed.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/utils/constants/ui_constants.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/utils/simple_bloc_observer.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/views/feed/blocs/feedroomlist/feedroom_list_bloc.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/views/feed/feedroom_list_screen.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/widgets/general_app_bar.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class FeedRoomSelect extends StatefulWidget {
  static const String route = "/feedroom_select";
  final User user;
  final List<FeedRoom> feedRoomIds;
  const FeedRoomSelect({
    super.key,
    required this.user,
    required this.feedRoomIds,
  });

  @override
  State<FeedRoomSelect> createState() => _FeedRoomSelectState();
}

class _FeedRoomSelectState extends State<FeedRoomSelect> {
  List<FeedRoom>? feedRoomIds;
  final ValueNotifier<bool> rebuildList = ValueNotifier(false);

  final List<FeedRoom> _feedRoomList = [];
  FeedRoomListBloc? _feedRoomListBloc;
  final PagingController<int, FeedRoom> _pagingControllerFeedRoomList =
      PagingController(firstPageKey: 1);

  void _addPaginationListener() {
    _pagingControllerFeedRoomList.addPageRequestListener((pageKey) {
      _feedRoomListBloc!.add(GetFeedRoomList(offset: pageKey));
    });
  }

  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    feedRoomIds = widget.feedRoomIds;
    _feedRoomListBloc = FeedRoomListBloc();
    _addPaginationListener();
    _feedRoomListBloc!.add(const GetFeedRoomList(offset: 1));
  }

  @override
  void dispose() {
    _pagingControllerFeedRoomList.dispose();
    rebuildList.dispose();
    _feedRoomListBloc?.close();
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

  bool checkIfFeedRoomIsInList(FeedRoom item) {
    bool isPresent = false;
    for (FeedRoom element in feedRoomIds!) {
      if (element.id == item.id) {
        isPresent = true;
        break;
      }
    }
    return isPresent;
  }

  @override
  Widget build(BuildContext context) {
    feedRoomIds = widget.feedRoomIds;
    return WillPopScope(
      onWillPop: () {
        locator<NavigationService>()
            .goBack(result: {'feedRoomIds': feedRoomIds});
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: GeneralAppBar(
            backgroundColor: kPrimaryColor,
            autoImplyEnd: false,
            backTap: () {
              locator<NavigationService>()
                  .goBack(result: {'feedRoomIds': feedRoomIds});
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Post in...',
                  style: TextStyle(color: kWhiteColor, fontSize: kFontMedium),
                ),
                ValueListenableBuilder(
                    valueListenable: rebuildList,
                    builder: (context, _, __) {
                      return Text(
                        '${feedRoomIds!.length} selected',
                        style: const TextStyle(
                            color: kWhiteColor,
                            fontWeight: FontWeight.w300,
                            fontSize: kFontMedium),
                      );
                    })
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: BlocConsumer<FeedRoomListBloc, FeedRoomListState>(
                  bloc: _feedRoomListBloc,
                  listener: (context, state) => updatePagingControllers(state),
                  buildWhen: (previous, current) {
                    if (current is FeedRoomListLoading &&
                        _feedRoomList.isNotEmpty) {
                      return false;
                    }
                    return true;
                  },
                  builder: ((context, state) {
                    if (state is FeedRoomListLoaded) {
                      return Column(
                        children: [
                          const SizedBox(height: 18),
                          ValueListenableBuilder(
                            valueListenable: rebuildList,
                            builder: (context, _, __) {
                              return Expanded(
                                child: PagedListView<int, FeedRoom>(
                                  pagingController:
                                      _pagingControllerFeedRoomList,
                                  builderDelegate:
                                      PagedChildBuilderDelegate<FeedRoom>(
                                    noMoreItemsIndicatorBuilder: (context) =>
                                        const SizedBox(height: 20),
                                    noItemsFoundIndicatorBuilder: (context) =>
                                        const Scaffold(
                                            backgroundColor: kBackgroundColor,
                                            body: Center(
                                              child: Loader(),
                                            )),
                                    itemBuilder: (context, item, index) {
                                      return Container(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              height: 54,
                                              width: 54,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(54),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    item.chatroomImageUrl!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            kHorizontalPaddingMedium,
                                            kHorizontalPaddingSmall,
                                            Text(
                                              item.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: kFontMedium,
                                              ),
                                            ),
                                            const Spacer(),
                                            Checkbox(
                                              value:
                                                  checkIfFeedRoomIsInList(item),
                                              onChanged: (value) {
                                                if (checkIfFeedRoomIsInList(
                                                    item)) {
                                                  feedRoomIds!.removeWhere(
                                                      (feedRoom) =>
                                                          feedRoom.id ==
                                                          item.id);
                                                } else {
                                                  feedRoomIds!.add(item);
                                                }
                                                rebuildList.value =
                                                    !rebuildList.value;
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else if (state is FeedRoomListLoading) {
                      return getFeedRoomListLoadingView();
                    } else if (state is FeedRoomListError) {
                      return getFeedRoomListErrorView(state.message);
                    } else if (state is FeedRoomListEmpty) {
                      return const SizedBox(
                        child: Column(
                          children: <Widget>[
                            Text('No feed room found'),
                          ],
                        ),
                      );
                    }
                    return const Scaffold(
                        backgroundColor: kBackgroundColor,
                        body: Center(
                          child: Loader(),
                        ));
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
