// ignore_for_file: prefer_const_constructors

import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/data/local_db/local_db_impl.dart';
import 'package:feed_sx/src/data/models/branding/branding.dart';
import 'package:feed_sx/src/data/repositories/branding/branding_repository.dart';
import 'package:feed_sx/src/sdk/branding_sdk.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/simple_bloc_observer.dart';
import 'package:feed_sx/src/theme.dart';
import 'package:feed_sx/src/views/feed/blocs/universal_feed/universal_feed_bloc.dart';
import 'package:feed_sx/src/views/feed/components/custom_feed_app_bar.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/views/new_post/new_post_screen.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final UniversalFeedBloc _feedBloc;
  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    _feedBloc = UniversalFeedBloc();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InitiateUserResponse>(
        future: locator<LikeMindsService>().initiateUser(
          InitiateUserRequest(
            userId: "5d428e4d-984d-4ab5-8d2b-0adcdbab2ad8",
            userName: "Divyansh Gandhi Integration",
          ),
        ),
        builder: (context, getAuthAPIsnapshot) {
          if (getAuthAPIsnapshot.hasData) {
            _feedBloc.add(GetUniversalFeed(offset: 1, forLoadMore: false));
            return MaterialApp(
              onGenerateRoute: (settings) {
                if (settings.name == AllCommentsScreen.route) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return AllCommentsScreen();
                    },
                  );
                }
                // if (settings.name == LikesScreen.route) {
                //   return MaterialPageRoute(
                //     builder: (context) {
                //       // return LikesScreen();
                //     },
                //   );
                // }
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
                  body: BlocBuilder(
                    bloc: _feedBloc,
                    builder: ((context, state) {
                      if (state is UniversalFeedLoaded) {
                        UniversalFeedResponse feedResponse = state.feed;
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final Post post = feedResponse.posts[index];
                            return PostWidget(
                                postType: post.attachments != null
                                    ? post.attachments!.first.attachmentType
                                    : 1,
                                postDetails: post,
                                user: feedResponse.users[post.userId]!);
                          },
                          itemCount: feedResponse.posts.length,
                        );
                      }
                      return Center(child: const Loader());
                    }),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return NewPostScreen();
                        },
                      ));
                    },
                    backgroundColor: kPrimaryColor,
                    child: const Icon(Icons.add),
                  )),
            );
          }
          return Center(child: const Loader());
        });
  }
}
