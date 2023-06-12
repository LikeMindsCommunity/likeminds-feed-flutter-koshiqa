import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:flutter/material.dart';

void routeNotification(String route) async {
  Map<String, String> queryParams = {};
  String host = "";

  // If the notification is a feed notification, extract the route params
  final Uri routeUri = Uri.parse(route);
  final Map<String, String> routeParams =
      routeUri.hasQuery ? routeUri.queryParameters : {};
  final String routeHost = routeUri.host;
  host = routeHost;
  debugPrint("The route host is $routeHost");
  queryParams.addAll(routeParams);
  queryParams.forEach((key, value) {
    debugPrint("$key: $value");
  });

  // Route the notification to the appropriate screen
  // If the notification is post related, route to the post detail screen
  if (host == "post_detail") {
    final String postId = queryParams["post_id"]!;
    locator<NavigationService>().navigateTo(
      AllCommentsScreen.route,
      arguments: AllCommentsScreenArguments(
        postId: postId,
        feedRoomId: locator<LikeMindsService>().feedroomId!,
      ),
    );
  }
}
