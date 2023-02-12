import 'package:feed_sx/src/services/service_locator.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class LMNotificationHandler {
  int? memberId;
  String? deviceId;
  String? fcmToken;

  static LMNotificationHandler? _instance;
  static LMNotificationHandler get instance =>
      _instance ??= LMNotificationHandler._();

  LMNotificationHandler._();

  void init(
    String deviceId,
    String fcmToken,
  ) {
    this.deviceId = deviceId;
    this.fcmToken = fcmToken;
  }

  void registerDevice(int memberId) async {
    RegisterDeviceRequest request = RegisterDeviceRequest(
      token: fcmToken!,
      memberId: memberId,
      deviceId: deviceId!,
    );
    this.memberId = memberId;
    final response = await locator<LikeMindsService>().registerDevice(request);
    if (response.success) {
      print("Device registered for notifications successfully");
    } else {
      throw Exception("Device registration for notification failed");
    }
  }

  Future<void> handleNotification(RemoteMessage message) async {
    //TODO: Add logic to handle notification
    // First, check if the message contains a data payload.
    // Second, check if this is a LM notification
    // Third, extract the notification data and routes to the appropriate screen
    message.data.forEach((key, value) {
      print("$key: $value");
    });
  }
}
