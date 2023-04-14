import 'dart:convert';

import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalPreference {
  SharedPreferences? _sharedPreferences;

  static UserLocalPreference? _instance;
  static UserLocalPreference get instance =>
      _instance ??= UserLocalPreference._();

  UserLocalPreference._();

  final String _domainKey = 'domain';
  final String _userKey = 'user';
  final String _memberStateKey = 'isCm';

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> storeUserData(User user) async {
    UserEntity userEntity = user.toEntity();
    Map<String, dynamic> userData = userEntity.toJson();
    String userString = jsonEncode(userData);
    _sharedPreferences!.setString(_userKey, userString);
  }

  User fetchUserData() {
    Map<String, dynamic> userData =
        jsonDecode(_sharedPreferences!.getString(_userKey)!);
    return User.fromEntity(UserEntity.fromJson(userData));
  }

  Future<void> storeMemberState(bool isCm) async {
    _sharedPreferences!.setBool(_memberStateKey, isCm);
  }

  bool fetchMemberState() {
    return _sharedPreferences!.getBool(_memberStateKey)!;
  }

  Future<void> storeAppDomain(String domain) async {
    _sharedPreferences!.setString(_domainKey, domain);
  }

  String getAppDomain() {
    return _sharedPreferences!.getString(_domainKey)!;
  }
}
