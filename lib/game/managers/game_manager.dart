import 'dart:ffi';
import 'dart:io';
import 'package:careful_icarus/game/DampenedCamera.dart';
import 'package:careful_icarus/game/managers/sound_manager.dart';
import 'package:careful_icarus/game/managers/upgrade_manager.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../util/util.dart';


import '../icarus.dart';

/// This class is used to manage the game. It is used to store the game's state and saves these values between sessions.
class GameManager extends Component with HasGameRef<Icarus> {
  static bool gameover = false;
  static num height = 0;
  static num heightRecord = 0;
  static const distanceToSun = 100000; //km
  static double timeToSunRecord = double.maxFinite;
  static DateTime levelStartTime = DateTime.now();
  static int fishGatheredRun = 0;
  static int fishGatheredTotal = 0;
  static bool manualControl = false;

  /// Bool for debugging (showing hitboxes and positions on screen)
  static const bool debugging = false;

  //Stats (powers)
  static int sealprotection = (UpgradeManager.upgrades["Sealion Protection"][
      "level"]); //A that protects the player from one collision with an enemy per level
  static double idleFisher = (UpgradeManager.upgrades["Idle Fisher"]["level"]) /
      10; //A powerup that automatically catches fish based on time played. Increments by 0.1 per upgrade.
  static double jumpStrength =
      (600 * (UpgradeManager.upgrades["Jump Strength"]["multiplier"]))
          .toDouble(); //How high the player can jump.
  static double launchStrength =
      (750 * (UpgradeManager.upgrades["Launch Strength"]["multiplier"]))
          .toDouble(); //How high the player is initially launched
  static double fishMultiplier = UpgradeManager.upgrades["Fish Multiplier"]
      ["multiplier"]; //Multiplier for fish gathered
  static double waxMax =
      (100 * (UpgradeManager.upgrades["Wax Integrity"]["multiplier"]))
          .toDouble(); //How much wax the player has left
  static double waxCurrent = 100; //Current timer for player

  static bool runOnce = false;

  static bool getAllUpgrades =
      true; //If true, all upgrades are unlocked instantly

  static void startLevel() {
    waxCurrent = waxMax;
    if (Platform.isAndroid) SoundManager.playMusic();
    gameover = false;
    levelStartTime = DateTime.now();

    //Reset stats
    fishGatheredRun = 0;
    height = 0;

    //testUpgrades(); //Used only for testing
  }

  static void testUpgrades() {
    if (getAllUpgrades) {
      sealprotection = 10;
      idleFisher = 0.5;
      jumpStrength = 1000;
      fishMultiplier = 10;
      waxMax = 500;
      waxCurrent = 500;
    }
  }

  static Future<void> win() async {
    SoundManager.stopMusic();

    if (timeToSunRecord > DateTime.now().difference(levelStartTime).inSeconds) {
      timeToSunRecord =
          DateTime.now().difference(levelStartTime).inSeconds.toDouble();
    }

    updateFish();

    gameover = true;
    Icarus.pause = true;
  }

  static Future<void> lose() async {
    SoundManager.stopMusic();
    if (!runOnce) {
      DampenedCamera.lockHeight = true;

      updateFish();
      if (Platform.isAndroid || Platform.isIOS) {
        Vibration.vibrate(duration: 100);
      } 
      gameover = true;
      Icarus.pause = true;

      runOnce = true;
    }
  }

  static Future<void> updateFish() async {
    int fishGatheredTotal = await readInt('fishGatheredTotal');
    int fishIdled = getFishIdled();
    int total = totalfish;
    fishGatheredTotal += total;
    UpgradeManager.fish = fishGatheredTotal;
    writeInt('fishGatheredTotal', fishGatheredTotal);
  }

  static int get totalfish {
    return ((fishGatheredRun + getFishIdled()) * fishMultiplier).toInt();
  }

  static int getFishIdled() =>
      (idleFisher * DateTime.now().difference(levelStartTime).inSeconds)
          .toInt();
}
