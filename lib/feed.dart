library feed;

import 'package:feed_sx/credentials.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
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
  final String? userId;
  final String? userName;

  static LMFeed? _instance;
  static LMFeed instance({String? userId, String? userName}) =>
      _instance ??= LMFeed._(userId: userId, userName: userName);

  const LMFeed._({
    Key? key,
    this.userId,
    this.userName,
  }) : super(key: key);

  @override
  _LMFeedState createState() => _LMFeedState();
}

class _LMFeedState extends State<LMFeed> {
  User? user;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InitiateUserResponse>(
      future: locator<LikeMindsService>().initiateUser(
        InitiateUserRequest(
          userId: widget.userId!.isEmpty ? BETA_BOT_ID : widget.userId,
          userName: widget.userName!.isEmpty ? "Jane Doe" : widget.userName,
          // userName: "Divyansh Gandhi Integration",
        ),
      ),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          InitiateUserResponse response = snapshot.data;
          if (response.success) {
            user = User.fromJson(response.data!["user"]);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              onGenerateRoute: (settings) {
                if (settings.name == AllCommentsScreen.route) {
                  final args = settings.arguments as AllCommentsScreenArguments;
                  return MaterialPageRoute(
                    builder: (context) {
                      return AllCommentsScreen(
                        post: args.post,
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
                      return const ReportPostScreen();
                    },
                  );
                }
                // if (settings.name == NewPostScreen.route) {
                //   return MaterialPageRoute(
                //     builder: (context) {
                //       return NewPostScreen();
                //     },
                //   );
                // }
              },
              home: FutureBuilder(
                future: locator<LikeMindsService>().getMemberState(),
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return FeedRoomScreen(
                      isCm: snapshot.data,
                      user: user!,
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            );
          } else {}
        }
        return Container();
      },
    );
  }
}
