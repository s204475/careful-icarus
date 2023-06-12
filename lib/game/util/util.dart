export 'color_schemes.dart';

import 'dart:math';

class Util {
  static final _random = new Random();
  static int nextInt(int min, int max) => min + _random.nextInt(max - min);
  static double nextDouble() => _random.nextDouble();
}
