import 'dart:ffi';

import 'package:careful_icarus/game/DampenedCamera.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';

/// This class is used to manage the game. It is used to store the game's state and saves these values between sessions.
class GameManager extends Component with HasGameRef<Icarus> {
  static const bool debugging = true;
  static bool gameover = false;
  static num height = 0;
  static const distanceToSun = 1519100000; //km
  static double timeToSunRecord = double.maxFinite;
  static DateTime levelStartTime = DateTime.now();

  static void startLevel() {
    gameover = false;
    levelStartTime = DateTime.now();
    print(
        'Level start: ${levelStartTime.hour}:${levelStartTime.minute}:${levelStartTime.second}.${levelStartTime.millisecond}');
    //reset stats
  }

  static void win() {
    debugPrint('Victory!');
    if (timeToSunRecord > DateTime.now().difference(levelStartTime).inSeconds) {
      timeToSunRecord =
          DateTime.now().difference(levelStartTime).inSeconds.toDouble();
      debugPrint('New record: $timeToSunRecord!');
    }
    gameover = true;
  }

  static void lose() {
    debugPrint('Defeat!');
    gameover = true;
    DampenedCamera.lockHeight = true;
    //stop camera
  }
}
