import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'controllers/controller.dart';

// game main function
class Icarus extends FlameGame {
  
  @override
  Color backgroundColor() => Colors.lightBlue;

  @override
  Future<void> onLoad() async {
    debugPrint("loading Game");
    addAll([PlayerControls()]);
  }
}
