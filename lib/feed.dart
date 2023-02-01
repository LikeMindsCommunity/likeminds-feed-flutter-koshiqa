library feed;

import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/views/feed/feedroom_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/services/likeminds_service.dart';

export 'src/views/feed/feed_screen.dart';
export 'src/views/likes/likes_screen.dart';
export 'src/views/report_post/report_screen.dart';
export 'src/views/comments/all_comments_screen.dart';
export 'src/views/new_post/new_post_screen.dart';
export 'src/views/following_tab/following_tab_screen.dart';
export 'src/service_locator.dart';

class LMFeed extends StatefulWidget {
  const LMFeed({Key? key}) : super(key: key);

  @override
  _LMFeedState createState() => _LMFeedState();
}

class _LMFeedState extends State<LMFeed> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InitiateUserResponse>(
      future: locator<LikeMindsService>().initiateUser(
        InitiateUserRequest(
          userId: "22b6a64f-66bf-4bca-800e-b40ca66f924d",
          // userName: "Divyansh Gandhi Integration",
        ),
      ),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) {
              if (settings.name == AllCommentsScreen.route) {
                final args = settings.arguments as AllCommentsScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return AllCommentsScreen(
                      postId: args.postId,
                    );
                  },
                );
              }
              // if (settings.name == LikesScreen.route) {
              //   return MaterialPageRoute(
              //     builder: (context) {
              //       return LikesScreen();
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
            home: FutureBuilder(
              future: locator<LikeMindsService>().getMemberState(),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return FeedRoomScreen(
                    isCm: snapshot.data,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
