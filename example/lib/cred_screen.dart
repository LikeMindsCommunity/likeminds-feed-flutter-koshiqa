import 'dart:async';

import 'package:feed_example/likeminds_callback.dart';
import 'package:feed_example/network_handling.dart';
import 'package:feed_example/user_local_preference.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/feed.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:uni_links/uni_links.dart';
import 'main.dart';

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

  StreamSubscription? _streamSubscription;
  LMFeed? lmFeed;
  DeepLinkResponse? deepLink;

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
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<DeepLinkResponse> initUniLinks() async {
    String? userId = UserLocalPreference.instance.fetchUserId();
    var deepLinkResponse;
    if (!initialURILinkHandled) {
      initialURILinkHandled = true;
      // Get the initial deep link if the app was launched with one
      final initialLink = await getInitialLink();

      // Handle the deep link
      if (initialLink != null) {
        // You can extract any parameters from the initialLink object here
        // and use them to navigate to a specific screen in your app
        debugPrint('Received initial deep link: $initialLink');

        // TODO: add api key to the DeepLinkRequest
        deepLinkResponse = SharePost().parseDeepLink((DeepLinkRequestBuilder()
              ..apiKey("")
              ..callback(LikeMindsCallback())
              ..feedRoomId(debug ? 83301 : 2238799)
              ..isGuest(false)
              ..link(initialLink)
              ..userName("Test User")
              ..userUniqueId(userId ?? "5d428e4d-984d-4ab5-8d2b-0adcdbab2ad8"))
            .build());
      }

      // Subscribe to link changes
      _streamSubscription = linkStream.listen((String? link) async {
        if (link != null) {
          // Handle the deep link
          // You can extract any parameters from the uri object here
          // and use them to navigate to a specific screen in your app
          debugPrint('Received deep link: $link');
          deepLinkResponse = SharePost().parseDeepLink((DeepLinkRequestBuilder()
                ..apiKey("")
                ..isGuest(false)
                ..callback(LikeMindsCallback())
                ..feedRoomId(debug ? 83301 : 2238799)
                ..link(link)
                ..userName("Test User")
                ..userUniqueId(
                    userId ?? "5d428e4d-984d-4ab5-8d2b-0adcdbab2ad8"))
              .build());
          deepLink = await deepLinkResponse;
          if (deepLink != null && deepLink!.success) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AllCommentsScreen(
                    postId: deepLink!.postId!,
                    feedRoomId: debug ? 83301 : 2238799,
                    fromComment: false),
              ),
            );
          }
        }
      }, onError: (err) {
        // Handle exception by warning the user their action did not succeed
        toast('An error occured');
      });
    }
    return deepLinkResponse ??
        DeepLinkResponse(
          success: false,
          errorMessage: 'An error occured, please try again later',
        );
  }

  @override
  Widget build(BuildContext context) {
    // return lmFeed;
    String? userId = UserLocalPreference.instance.fetchUserId();
    // If the local prefs have user id stored
    // Login using that user Id
    // otherwise show the cred screen for login
    if (userId != null && userId.isNotEmpty) {
      return FutureBuilder(
          future: initUniLinks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data!.success) {
              lmFeed = LMFeed.instance(
                userId: _userIdController.text,
                userName: _usernameController.text,
                defaultFeedroom: debug ? 83301 : 2238799,
                callback: LikeMindsCallback(),
                deepLinkCallBack: () {
                  debugPrint("Deep Link Callback");
                },
                domain: 'feedsx://www.feedsx.com',
                postId: snapshot.data!.postId,
                apiKey: "",
              );
              return lmFeed!;
            } else {
              lmFeed = LMFeed.instance(
                userId: _userIdController.text,
                userName: _usernameController.text,
                defaultFeedroom: debug ? 83301 : 2238799,
                callback: LikeMindsCallback(),
                deepLinkCallBack: () {
                  debugPrint("Deep Link Callback");
                },
                domain: 'feedsx://www.feedsx.com',
                apiKey: "",
              );
              return lmFeed!;
            }
          });
    } else {
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
                onTap: () async {
                  DeepLinkResponse? response = await deepLink;
                  String? postId;
                  if (response != null && response.success) {
                    postId = response.postId!;
                  }
                  lmFeed = LMFeed.instance(
                    userId: _userIdController.text,
                    userName: _usernameController.text,
                    defaultFeedroom: debug ? 83301 : 2238799,
                    callback: LikeMindsCallback(),
                    deepLinkCallBack: () {
                      debugPrint("Deep Link Callback");
                    },
                    domain: 'feedsx://www.feedsx.com',
                    postId: postId,
                    apiKey: "",
                  );

                  if (_userIdController.text.isNotEmpty) {
                    await UserLocalPreference.instance.initialize();
                    UserLocalPreference.instance
                        .storeUserId(_userIdController.text);
                  }
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
}
