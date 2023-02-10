import 'package:device_info_plus/device_info_plus.dart';
import 'package:feed_example/cred_screen.dart';
import 'package:feed_sx/feed.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _handleNotification(RemoteMessage message) async {
  print("Notification received in LEVEL 1 - ${message.data}");
  LMNotificationHandler.instance.handleNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FINALLY - Set the notification handler to listen for notifications
  FirebaseMessaging.onBackgroundMessage(_handleNotification);
  setupLocator();
  final devId = await deviceId();
  final fcmToken = await setupMessaging();
  //STEP 1 - Initialize the notification handler
  LMNotificationHandler.instance.init(devId, fcmToken);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _handleNotification(message);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CredScreen(),
    );
  }
}

Future<String> deviceId() async {
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  final deviceId =
      deviceInfo.data["identifierForVendor"] ?? deviceInfo.data["id"];
  print("Device id - $deviceId");
  return deviceId.toString();
}

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
