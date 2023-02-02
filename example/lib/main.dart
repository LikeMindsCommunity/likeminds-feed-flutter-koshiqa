import 'package:feed_sx/feed.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  setupLocator();
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
      home: CredScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 92, 193),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(
              height: 72,
            ),
            Text(
              "Koshiqa Beta\nSample App",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 64),
            Text("Enter your credentials",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                )),
            SizedBox(
              height: 18,
            ),
            TextField(
              cursorColor: Colors.white,
              controller: _usernameController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Username',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'User ID',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              height: 36,
            ),
            GestureDetector(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => LMFeed.instance(
                        userId: _userIdController.text,
                        userName: _usernameController.text));
                Navigator.pushReplacement(context, route);
              },
              child: Container(
                width: 200,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text("Submit")),
              ),
            ),
            SizedBox(height: 72),
            Text(
                "If no credentials are provided, the app will run with the default credentials of Bot user in your community",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }
}
