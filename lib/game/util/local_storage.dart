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
