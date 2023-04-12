import 'dart:convert';

import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalPreference {
  SharedPreferences? _sharedPreferences;

  static UserLocalPreference? _instance;
  static UserLocalPreference get instance =>
      _instance ??= UserLocalPreference._();

  UserLocalPreference._();

  Future initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void storeUserData(User user) {
    print(DateTime.now().millisecondsSinceEpoch);
    UserEntity userEntity = user.toEntity();
    Map<String, dynamic> userData = userEntity.toJson();
    String userString = jsonEncode(userData);
    _sharedPreferences!.setString('user', userString);
    print(DateTime.now().millisecondsSinceEpoch);
  }

  User fetchUserData() {
    Map<String, dynamic> userData =
        jsonDecode(_sharedPreferences!.getString('user')!);
    return User.fromEntity(UserEntity.fromJson(userData));
  }

  void storeMemberState(bool isCm) {
    _sharedPreferences!.setBool('isCm', isCm);
  }

  bool fetchMemberState() {
    return _sharedPreferences!.getBool('isCm')!;
  }
}
