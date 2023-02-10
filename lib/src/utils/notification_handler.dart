import 'package:feed_sx/src/service_locator.dart';
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
    // print("Register Device Response - ${response.toString()}");
  }

  Future<void> handleNotification(RemoteMessage message) async {
    print("Notification received - ${message.notification!.title}");
    message.data.forEach((key, value) {
      print("$key: $value");
    });
  }
}
