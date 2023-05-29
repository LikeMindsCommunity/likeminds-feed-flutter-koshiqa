import 'package:feed_example/likeminds_callback.dart';
import 'package:feed_example/network_handling.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/feed.dart';
import 'package:overlay_support/overlay_support.dart';

const debug = bool.fromEnvironment('DEBUG');

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Integration App for UI + SDK package',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CredScreen(),
      ),
    );
  }
}

class CredScreen extends StatefulWidget {
  const CredScreen({super.key});

  @override
  State<CredScreen> createState() => _CredScreenState();
}

class _CredScreenState extends State<CredScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  LMFeed? lmFeed;

  @override
  void initState() {
    super.initState();
    NetworkConnectivity networkConnectivity = NetworkConnectivity.instance;
    networkConnectivity.initialise();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 92, 193),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            const SizedBox(height: 72),
            const Text(
              "Koshiqa Beta\nSample App",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 64),
            const Text(
              "Enter your credentials",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              controller: _usernameController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Username',
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              cursorColor: Colors.white,
              controller: _userIdController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'User ID',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  )),
            ),
            const SizedBox(height: 36),
            GestureDetector(
              onTap: () {
                lmFeed = LMFeed.instance(
                  userId: _userIdController.text,
                  userName: _usernameController.text,
                  defaultFeedroom: debug ? 72200 : 1262837,
                  callback: LikeMindsCallback(),
                  apiKey: "",
                );
                MaterialPageRoute route = MaterialPageRoute(
                  // INIT - Get the LMFeed instance and pass the credentials (if any)
                  builder: (context) => lmFeed!,
                );
                Navigator.pushReplacement(context, route);
              },
              child: Container(
                width: 200,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text("Submit")),
              ),
            ),
            const SizedBox(height: 72),
            const Text(
              "If no credentials are provided, the app will run with the default credentials of Bot user in your community",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
