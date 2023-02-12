library feed;

import 'package:feed_sx/credentials.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/views/feed/feedroom_screen.dart';
import 'package:flutter/material.dart';
import 'src/services/likeminds_service.dart';

export 'src/views/feed/feed_screen.dart';
export 'src/views/likes/likes_screen.dart';
export 'src/views/report_post/report_screen.dart';
export 'src/views/comments/all_comments_screen.dart';
export 'src/views/new_post/new_post_screen.dart';
export 'src/views/following_tab/following_tab_screen.dart';
export 'src/services/service_locator.dart';
export 'src/utils/notification_handler.dart';

class LMFeed extends StatefulWidget {
  final String? userId;
  final String? userName;

  static LMFeed? _instance;
  static LMFeed instance({
    String? userId,
    String? userName,
  }) =>
      _instance ??= LMFeed._(
        userId: userId,
        userName: userName,
      );

  const LMFeed._({
    Key? key,
    this.userId,
    this.userName,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LMFeedState createState() => _LMFeedState();
}

class _LMFeedState extends State<LMFeed> {
  User? user;

  @override
  void initState() {
    super.initState();
    firebase();
  }

  firebase() {
    try {
      final firebase = Firebase.app();
      print("Firebase - ${firebase.options.appId}");
    } on FirebaseException catch (e) {
      print("Make sure you have initialized firebase, ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InitiateUserResponse>(
      future: locator<LikeMindsService>().initiateUser(
        InitiateUserRequest(
          userId: widget.userId!.isEmpty ? BETA_BOT_ID : widget.userId,
          userName: widget.userName!.isEmpty ? "Jane Doe" : widget.userName,
        ),
      ),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          InitiateUserResponse response = snapshot.data;
          if (response.success) {
            user = User.fromJson(response.data!["user"]);
            LMNotificationHandler.instance.registerDevice(user!.id);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
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
