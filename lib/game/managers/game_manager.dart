import 'dart:ffi';

import 'package:careful_icarus/game/DampenedCamera.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../util/util.dart';

import '../icarus.dart';

/// This class is used to manage the game. It is used to store the game's state and saves these values between sessions.
class GameManager extends Component with HasGameRef<Icarus> {
  static const bool debugging = true;
  static bool gameover = false;
  static num height = 0;
  static const distanceToSun = 100000; //km
  static double timeToSunRecord = double.maxFinite;
  static DateTime levelStartTime = DateTime.now();
  static int fishGathered = 0;

  static void startLevel() {
    gameover = false;
    levelStartTime = DateTime.now();
    print(
        'Level start: ${levelStartTime.hour}:${levelStartTime.minute}:${levelStartTime.second}.${levelStartTime.millisecond}');
    //reset stats
  }

  static Future<void> win() async {
    debugPrint('Victory!');
    if (timeToSunRecord > DateTime.now().difference(levelStartTime).inSeconds) {
      timeToSunRecord =
          DateTime.now().difference(levelStartTime).inSeconds.toDouble();
      debugPrint('New record: $timeToSunRecord!');
    }
    int total = await readInt('totalFishGathered') + fishGathered;
    writeInt('totalFishGathered', total);
    gameover = true;
    Icarus.pause = true;
  }

  static bool runOnce = false;
  static Future<void> lose() async {
    if (!runOnce) {
      DampenedCamera.lockHeight = true;
      debugPrint('Defeat!');
      gameover = true;
      Icarus.pause = true;
      int total = await readInt('totalFishGathered') + fishGathered;
      writeInt('totalFishGathered', total);
      print('Total fish gathered: $total');
      runOnce = true;
    }
  }
}
