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
  static num heightRecord = 0;
  static const distanceToSun = 100000; //km
  static double timeToSunRecord = double.maxFinite;
  static DateTime levelStartTime = DateTime.now();
  static int fishGatheredRun = 0;
  static int fishGatheredTotal = 0;

  //Stats (powers)
  static bool sealprotection =
      false; //A one-use powerup that protects the player from one collision with an enemy
  static double idleFisher =
      0; //A powerup that automatically catches fish based on time played. Increments by 0.1 per upgrade.
  static double jumpStrength = 600; //How high the player can jump.
  static double fishMultiplier = 1; //Multiplier for fish gathered
  static double waxIntegrity = 100; //How much wax the player has left

  static bool runOnce = false;

  static bool getAllUpgrades =
      true; //If true, all upgrades are unlocked instantly

  static void startLevel() {
    gameover = false;
    levelStartTime = DateTime.now();
    print(
        'Level start: ${levelStartTime.hour}:${levelStartTime.minute}:${levelStartTime.second}.${levelStartTime.millisecond}');

    //Reset stats
    fishGatheredRun = 0;
    height = 0;

    testUpgrades();
  }

  static void testUpgrades() {
    if (getAllUpgrades) {
      sealprotection = true;
      idleFisher = 0.5;
      jumpStrength = 1000;
      fishMultiplier = 10;
      waxIntegrity = 500;
    }
  }

  static Future<void> win() async {
    debugPrint('Victory!');
    if (timeToSunRecord > DateTime.now().difference(levelStartTime).inSeconds) {
      timeToSunRecord =
          DateTime.now().difference(levelStartTime).inSeconds.toDouble();
      debugPrint('New record: $timeToSunRecord!');
    }

    updateFish();

    gameover = true;
    Icarus.pause = true;
  }

  static Future<void> lose() async {
    if (!runOnce) {
      DampenedCamera.lockHeight = true;
      debugPrint('Defeat!');

      updateFish();

      gameover = true;
      Icarus.pause = true;

      runOnce = true;
    }
  }

  static void updateFish() {
    int fishIdled =
        (idleFisher * DateTime.now().difference(levelStartTime).inSeconds)
            .toInt();
    int total = ((fishGatheredRun + fishIdled) * fishMultiplier).toInt();
    debugPrint(
        'Fish idled: $fishIdled \nFish gathered: $fishGatheredRun \nTotal fish gathered (multiplier = $fishMultiplier): $total');
    fishGatheredTotal += total;
  }
}
