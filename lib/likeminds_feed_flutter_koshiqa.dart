library likeminds_feed_ss_fl;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeminds_feed_flutter_core/likeminds_feed_core.dart';
import 'package:likeminds_feed_flutter_koshiqa/koshiqa_theme.dart';
export 'package:likeminds_feed_flutter_core/likeminds_feed_core.dart';

class LMFeedKoshiqa extends StatefulWidget {
  final String userId;
  final String userName;
  final int? feedroomId;
  final Function(BuildContext)? openChatCallback;

  const LMFeedKoshiqa({
    super.key,
    required this.userId,
    required this.userName,
    this.feedroomId,
    this.openChatCallback,
  });

  @override
  State<LMFeedKoshiqa> createState() => _LMFeedKoshiqaState();

  static Future<void> setupFeed({
    required String apiKey,
    String? domain,
    LMFeedClient? lmFeedClient,
    LMFeedThemeData? lmTheme,
    LMFeedConfig? lmConfig,
    GlobalKey<ScaffoldMessengerState>? lmScaffoldKey,
  }) async {
    await LMFeedCore.instance.initialize(
      apiKey: apiKey,
      domain: domain,
      lmFeedClient: lmFeedClient,
      scaffoldMessengerKey: lmScaffoldKey,
      theme: lmTheme ?? koshiqaTheme,
      config: lmConfig ??
          LMFeedConfig(
            globalSystemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
    );
  }
}

class _LMFeedKoshiqaState extends State<LMFeedKoshiqa> {
  Future<InitiateUserResponse>? initiateUser;
  Future<MemberStateResponse>? memberState;

  @override
  void initState() {
    super.initState();
    InitiateUserRequestBuilder requestBuilder = InitiateUserRequestBuilder()
      ..uuid(widget.userId)
      ..userName(widget.userName);

    initiateUser = LMFeedCore.instance.initiateUser(requestBuilder.build())
      ..then(
        (value) async {
          if (value.success) {
            memberState = LMFeedCore.instance.getMemberState();
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<InitiateUserResponse>(
        future: initiateUser,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.success) {
            return FutureBuilder<MemberStateResponse>(
                future: memberState,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.success) {
                    final isCm = LMFeedUserUtils.checkIfCurrentUserIsCM();
                    if (!isCm && widget.feedroomId == null) {
                      throw Exception(
                          "You need to provide an LM FeedRoom ID if the user being logged in is not a community manager");
                    }
                    return isCm
                        ? const LMFeedRoomListScreen()
                        : LMFeedRoomScreen(feedroomId: widget.feedroomId!);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const LMFeedLoader();
                  } else {
                    return const Center(
                      child: Text("An error occurred"),
                    );
                  }
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const LMFeedLoader();
          } else {
            return const Center(
              child: Text("Please check your internet connection"),
            );
          }
        },
      ),
    );
  }
}
