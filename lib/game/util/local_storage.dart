import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Read a int for the given name from local storage
Future<int> readInt(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getInt(name) ?? 0;

  return data;
}

/// Write a int for the given name from local storage
Future<void> writeInt(String name, int value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(name, value);
}

/// Write a map to local storage, first encoding it to json then saving it
Future<void> writeMap(String name, Map value) async {
  final prefs = await SharedPreferences.getInstance();
  String encodedMap = json.encode(value);
  await prefs.setString(name, encodedMap);
}

/// read a json string from the local storage and decode it to a map
Future<Map> readMap(String name) async {
  final prefs = await SharedPreferences.getInstance();
  String? encodedMap = prefs.getString(name);
  if (encodedMap != null) {
    return json.decode(encodedMap);
  } else {
    return {};
  }
}
