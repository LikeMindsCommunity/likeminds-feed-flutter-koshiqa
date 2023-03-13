// ignore_for_file: library_private_types_in_public_api

library feed;

import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/credentials/credentials.dart';
import 'package:feed_sx/src/views/feed/feedroom_list_screen.dart';
import 'package:feed_sx/src/views/previews/image_preview.dart';
import 'package:feed_sx/src/views/tagging_test.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/views/feed/feedroom_screen.dart';
import 'package:flutter/material.dart';
import 'src/navigation/navigation_service.dart';
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
  final bool isProd;
  static LMFeed? _instance;

  /// INIT - Get the LMFeed instance and pass the credentials (if any)
  /// to the instance. This will be used to initialize the app.
  /// If no credentials are provided, the app will run with the default
  /// credentials of Bot user in your community in `credentials.dart`
  static LMFeed instance({
    String? userId,
    String? userName,
    bool isProd = false,
  }) {
    return _instance ??= LMFeed._(
      userId: userId,
      userName: userName,
      isProd: isProd,
    );
  }

  const LMFeed._({
    Key? key,
    this.userId,
    this.userName,
    required this.isProd,
  }) : super(key: key);

  @override
  _LMFeedState createState() => _LMFeedState();
}

class _LMFeedState extends State<LMFeed> {
  User? user;
  late final String userId;
  late final String userName;
  late final bool isProd;

  @override
  void initState() {
    super.initState();
    isProd = widget.isProd;
    userId = widget.userId!.isEmpty
        ? isProd
            ? CredsProd.botId
            : CredsDev.botId
        : widget.userId!;
    userName = widget.userName!.isEmpty ? "Test username" : widget.userName!;
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
          userId: userId,
          userName: userName,
        ),
      ),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          InitiateUserResponse response = snapshot.data;
          if (response.success) {
            user = response.initiateUser?.user;
            LMNotificationHandler.instance.registerDevice(user!.id);
            return MaterialApp(
              debugShowCheckedModeBanner: !isProd,
              title: 'LikeMinds Feed',
              navigatorKey: locator<NavigationService>().navigatorKey,
              onGenerateRoute: (settings) {
                if (settings.name == AllCommentsScreen.route) {
                  final args = settings.arguments as AllCommentsScreenArguments;
                  return MaterialPageRoute(
                    builder: (context) {
                      return AllCommentsScreen(
                        post: args.post,
                        feedRoomId: args.feedroomId,
                      );
                    },
                  );
                }
                if (settings.name == LikesScreen.route) {
                  final args = settings.arguments as LikesScreenArguments;
                  return MaterialPageRoute(
                    builder: (context) {
                      return LikesScreen(
                        response: args.response,
                        postId: args.postId,
                      );
                    },
                  );
                }
                if (settings.name == ReportPostScreen.route) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return const ReportPostScreen();
                    },
                  );
                }
                if (settings.name == NewPostScreen.route) {
                  final args = settings.arguments as NewPostScreenArguments;
                  return MaterialPageRoute(
                    builder: (context) {
                      return NewPostScreen(
                        feedRoomId: args.feedroomId,
                        user: args.user,
                      );
                    },
                  );
                }
                if (settings.name == ImagePreview.route) {
                  final args = settings.arguments as ImagePreviewArguments;
                  return MaterialPageRoute(
                    builder: (context) {
                      return ImagePreview(
                        url: args.url,
                        postId: args.postId,
                      );
                    },
                  );
                }
              },
              home: FutureBuilder(
                future: locator<LikeMindsService>().getMemberState(),
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return FeedRoomListScreen(user: user!);
                    } else {
                      return FeedRoomScreen(
                        isCm: snapshot.data,
                        user: user!,
                        feedRoomId: DUMMY_FEEDROOM,
                      );
                    }
                    // return TaggingTestView();
                  }

                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: kBackgroundColor,
                    child: const Center(
                      child: Loader(
                        isPrimary: true,
                      ),
                    ),
                  );
                },
              ),
            );
          } else {}
        }
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: kBackgroundColor,
        );
      },
    );
  }
}
