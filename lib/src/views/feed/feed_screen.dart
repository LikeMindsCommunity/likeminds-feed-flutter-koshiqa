// ignore_for_file: prefer_const_constructors

import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/data/local_db/local_db_impl.dart';
import 'package:feed_sx/src/data/models/branding/branding.dart';
import 'package:feed_sx/src/data/repositories/branding/branding_repository.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/sdk/branding_sdk.dart';
import 'package:feed_sx/src/simple_bloc_observer.dart';
import 'package:feed_sx/src/theme.dart';
import 'package:feed_sx/src/views/feed/blocs/universal_feed/universal_feed_bloc.dart';
import 'package:feed_sx/src/views/feed/components/custom_feed_app_bar.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:feed_sdk/feed_sdk.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final SdkApplication _sdkApplication;
  late final FeedApi _feedApi;
  late final UniversalFeedBloc _feedBloc;
  static const _pageSize = 20;

  final PagingController<int, Post> _pagingController = PagingController(
    firstPageKey: 1,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    // likeMindsFeedSDK = LikeMindsFeedSDK();
    _sdkApplication = LikeMindsFeedSDK.initiateLikeMinds(
        'ae9e87b8-3448-457e-af1c-1dc6b544e2a4');

    //TODO :Insert api key here
    _feedApi = _sdkApplication.getFeedApi();
    _feedBloc = UniversalFeedBloc(feedApi: _feedApi);
  }

  _addPaginationListener() {
    _pagingController.addPageRequestListener((pageKey) {
      _feedBloc.add(GetUniversalFeed(offset: pageKey, forLoadMore: true));
    });
  }

  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InitiateUserResponse>(
        future: _sdkApplication
            .getAuthApi()
            .initiateUser(InitiateUserRequest(userId: 'dgd', userName: 'gfgg')),
        builder: (context, getAuthAPIsnapshot) {
          if (getAuthAPIsnapshot.hasData) {
            _addPaginationListener();
            _feedBloc.add(GetUniversalFeed(offset: 1, forLoadMore: false));
            print(
                'auth snapshot has data' + getAuthAPIsnapshot.data.toString());
            return RepositoryProvider<FeedApi>(
                create: (context) => _feedApi,
                child: MaterialApp(
                  onGenerateRoute: (settings) {
                    if (settings.name == AllCommentsScreen.route) {
                      final args =
                          settings.arguments as AllCommentsScreenArguments;
                      return MaterialPageRoute(
                        builder: (context) {
                          return AllCommentsScreen(
                            postId: args.postId,
                          );
                        },
                      );
                    }
                    if (settings.name == LikesScreen.route) {
                      return MaterialPageRoute(
                        builder: (context) {
                          return LikesScreen();
                        },
                      );
                    }
                    if (settings.name == ReportPostScreen.route) {
                      return MaterialPageRoute(
                        builder: (context) {
                          return ReportPostScreen();
                        },
                      );
                    }
                    if (settings.name == NewPostScreen.route) {
                      return MaterialPageRoute(
                        builder: (context) {
                          return NewPostScreen();
                        },
                      );
                    }
                  },
                  home: Scaffold(
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
                            _pagingController.appendPage(
                                state.feed.posts, _page);
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
                                  postType: 1,
                                  postDetails: item,
                                  user: feedResponse.users[item.userId]!),
                            ),
                          );
                          // return ListView.builder(
                          //   itemBuilder: (context, index) {
                          //     return PostWidget(
                          //         postType: 1,
                          //         postDetails: feedResponse.posts[index],
                          //         user: feedResponse.users[
                          //             feedResponse.posts[index].userId]!);
                          //   },
                          //   itemCount: feedResponse.posts.length,
                          // );
                        }
                        return Center(child: const Loader());
                      }),
                    ),
                  ),
                ));
          }
          return Center(child: const Loader());
        });
  }
}
