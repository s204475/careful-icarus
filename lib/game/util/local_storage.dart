import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<int> readInt(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getInt(name) ?? 0;

  return data;
}

Future<void> writeInt(String name, int value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(name, value);
}

Future<void> writeMap(String name, Map value) async {
  final prefs = await SharedPreferences.getInstance();
  String encodedMap = json.encode(value);
  await prefs.setString(name, encodedMap);
}

Future<Map> readMap(String name) async {
  final prefs = await SharedPreferences.getInstance();
  String? encodedMap = prefs.getString(name);
  if (encodedMap != null) {
    return json.decode(encodedMap);
  } else {
    return {};
  }
}
