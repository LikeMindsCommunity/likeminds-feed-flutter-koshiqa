import 'package:flutter/material.dart';

// class NavigationService {
//   late final GlobalKey<NavigatorState> navigatorKey;

//   static NavigationService? _instance;
//   static NavigationService get instance => _instance ??= NavigationService._();

//   NavigationService._();

//   void initialize(GlobalKey<NavigatorState> key) {
//     navigatorKey = key;
//   }

//   Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
//     return navigatorKey.currentState!.pushNamed(
//       routeName,
//       arguments: arguments,
//     );
//   }
// }

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    print(navigatorKey.currentState!.toString());
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
