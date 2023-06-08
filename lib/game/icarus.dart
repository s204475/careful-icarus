import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'player_controller.dart';

// game main function
class Icarus extends Forge2DGame {
  
  @override
  Color backgroundColor() => Colors.lightBlue;

  @override
  Future<void> onLoad() async {
    debugPrint("loading Game");
    addAll([PlayerControls()]);
  }
}
