import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/navigation/navigation_service.dart';
import 'package:feed_sx/src/services/service_locator.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/views/comments/all_comments_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:overlay_support/overlay_support.dart';

/// This class handles all the notification related logic
/// It registers the device for notifications in the SDK
/// It handles the notification when it is received and shows it
/// It routes the notification to the appropriate screen
/// Since this is a singleton class, it is initialized on the client side
class LMNotificationHandler {
  // late final Key notifKey;
  late final String deviceId;
  late final String fcmToken;
  int? memberId;

  static LMNotificationHandler? _instance;
  static LMNotificationHandler get instance =>
      _instance ??= LMNotificationHandler._();

  LMNotificationHandler._();

  /// Initialize the notification handler
  /// This is called from the client side
  /// It initializes the [fcmToken] and the [deviceId]
  /// It also initializes the [notifKey] which is used to show the notification
  void init({
    required String deviceId,
    required String fcmToken,
    // String notifKey = "likeminds-notification",
  }) {
    this.deviceId = deviceId;
    this.fcmToken = fcmToken;
    // this.notifKey = ValueKey(notifKey);
  }

  /// Register the device for notifications
  /// This is called from the client side
  /// It calls the [registerDevice] method of the [LikeMindsService]
  /// It initializes the [memberId] which is used to route the notification
  /// If the registration is successful, it prints success message
  void registerDevice(int memberId) async {
    RegisterDeviceRequest request = RegisterDeviceRequest(
      token: fcmToken,
      memberId: memberId,
      deviceId: deviceId,
    );
    this.memberId = memberId;
    final response = await locator<LikeMindsService>().registerDevice(request);
    if (response.success) {
      print("Device registered for notifications successfully");
    } else {
      throw Exception("Device registration for notification failed");
    }
  }

  /// Handle the notification when it is received
  /// This is called from the client side when notification [message] is received
  /// and is needed to be handled, i.e. shown and routed to the appropriate screen
  Future<void> handleNotification(RemoteMessage message, bool show) async {
    print("--- Notification received in LEVEL 2 ---");
    if (show && message.data.isNotEmpty) {
      showNotification(message);
    } else if (message.data.isNotEmpty) {
      routeNotification(message);
    } else if (message.notification != null) {
      print("Notification data is empty");
      message.toMap().forEach((key, value) {
        print("$key: $value");
      });
    }
    //TODO: Add logic to handle notification
    // First, check if the message contains a data payload.
    // Second, check if this is a LM notification
    // Third, extract the notification data and routes to the appropriate screen
    // message.data.forEach((key, value) {
    //   print("$key: $value");
    // });
    message.toMap().forEach((key, value) {
      print("$key: $value");
    });
  }

  void routeNotification(RemoteMessage message) async {
    Map<String, String> queryParams = {};
    String host = "";
    if (message.data.isNotEmpty) {
      final Map<String, dynamic> notifData = message.data;
      final String category = notifData["category"];
      final String route = notifData["route"]!;

      if (category.toString().toLowerCase() == "feed") {
        final Uri routeUri = Uri.parse(route);
        final Map<String, String> routeParams =
            routeUri.hasQuery ? routeUri.queryParameters : {};
        final String routeHost = routeUri.host;
        host = routeHost;
        print("The route host is $routeHost");
        queryParams.addAll(routeParams);
        queryParams.forEach((key, value) {
          print("$key: $value");
        });
      }
    }
    if (host == "post_detail") {
      final String postId = queryParams["post_id"]!;
      final GetPostResponse postDetails =
          await locator<LikeMindsService>().getPost(
        GetPostRequest(
          postId: postId,
          page: 1,
          pageSize: 10,
        ),
      );
      locator<NavigationService>().navigateTo(
        AllCommentsScreen.route,
        arguments: AllCommentsScreenArguments(
          post: postDetails.post!,
        ),
      );
    }
  }

  /// Show a simple notification using overlay package
  /// This is a dismissable notification shown on the top of the screen
  /// It is shown when the notification is received in foreground
  void showNotification(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      showSimpleNotification(
        // key: notifKey.runtimeType == ValueKey ? notifKey : const ValueKey(""),
        GestureDetector(
          onTap: () {
            routeNotification(message);
          },
          child: Text(
            message.data["sub_title"],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        background: Colors.white,
        duration: const Duration(seconds: 3),
        leading: Icon(
          Icons.notifications,
          color: Colors.blue.shade400,
          size: 24,
        ),
        trailing: Icon(
          Icons.swipe_right_outlined,
          color: Colors.grey.shade400,
          size: 18,
        ),
        position: NotificationPosition.top,
        slideDismissDirection: DismissDirection.horizontal,
      );
    }
  }
}
