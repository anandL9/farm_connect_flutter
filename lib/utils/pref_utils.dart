import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void setCheckInStatus(bool value) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  _pref.setBool('checkInStatus', value);
}

Future<bool> getCheckInStatus() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  return _pref.getBool('checkInStatus') ?? false;
}

void setUserData(Map<String, dynamic> userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userData', jsonEncode(userData));
}

Future<String?> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userData');
}

void deleteAllSPData() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}
