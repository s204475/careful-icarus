export 'color_schemes.dart';
export 'local_storage.dart';
import 'dart:math';

/// A class containing useful functions for the game. All functions are static and can be called without an instance of the class.
class Util {
  static final _random = Random();
  static int nextInt(int min, int max) => min + _random.nextInt(max - min);
  static double nextDouble() => _random.nextDouble();
}
