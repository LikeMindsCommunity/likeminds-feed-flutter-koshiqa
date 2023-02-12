import 'package:device_info_plus/device_info_plus.dart';
import 'package:feed_example/cred_screen.dart';
import 'package:feed_example/likeminds_callback.dart';
import 'package:feed_sx/feed.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

/// First level notification handler
/// Essential to declare it outside of any class or function as per Firebase docs
Future<void> _handleNotification(RemoteMessage message) async {
  print("--- Notification received in LEVEL 1 ---");
  showNotification(message);
  await LMNotificationHandler.instance.handleNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_handleNotification);
  setupLocator(LikeMindsCallback());
  setupNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CredScreen(),
      ),
    );
  }
}

/// Setup notifications
/// 1. Get device id - [deviceId]
/// 2. Get FCM token - [setupMessaging]
/// 3. Register device with LM - [LMNotificationHandler]
/// 4. Listen for notifications
/// 5. Handle notifications - [_handleNotification]
void setupNotifications() async {
  final devId = await deviceId();
  final fcmToken = await setupMessaging();
  LMNotificationHandler.instance.init(devId, fcmToken);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _handleNotification(message);
  });
}

/// Get device id
/// 1. Get device info
/// 2. Get device id
/// 3. Return device id
Future<String> deviceId() async {
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  final deviceId =
      deviceInfo.data["identifierForVendor"] ?? deviceInfo.data["id"];
  print("Device id - $deviceId");
  return deviceId.toString();
}

/// Setup Firebase messaging
/// 1. Get messaging instance
/// 2. Get FCM token
/// 3. Request permission
/// 4. Return FCM token
Future<String> setupMessaging() async {
  final messaging = FirebaseMessaging.instance;
  final token = await messaging.getToken();
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  print("Token - $token");
  return token.toString();
}

/// Show a simple notification using overlay package
void showNotification(RemoteMessage message) {
  if (message.data.isNotEmpty) {
    print("Notification received - ${message.data["sub_title"]}");
    showSimpleNotification(
      Text(
        message.data["sub_title"],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      background: Colors.white,
      duration: const Duration(seconds: 5),
      leading: Icon(
        Icons.notifications,
        color: Colors.blue.shade400,
        size: 24,
      ),
      trailing: Icon(
        Icons.close,
        color: Colors.grey.shade400,
        size: 18,
      ),
      position: NotificationPosition.top,
      slideDismissDirection: DismissDirection.horizontal,
    );
  }
}
