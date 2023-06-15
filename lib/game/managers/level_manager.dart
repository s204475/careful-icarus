import 'package:careful_icarus/game/icarus.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import '../DampenedCamera.dart';
import '../controllers/enemy.dart';
import 'game_manager.dart';
import '../controllers/player.dart';
import '../controllers/platform.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import '../sprites/background.dart';
import '../util/util.dart';

/// Handles creation of the actual level, including the player, platforms, and background
/// Also handles game over and winning logic
class LevelManager extends Component with HasGameRef<Icarus> {
  static late Player player;
  late CameraComponent cameraComponent;
  int lastYpos = 0;

  LevelManager(Icarus icarus, DampenedCamera cameraComponent) {
    player = Player();
    // ignore: prefer_initializing_formals
    this.cameraComponent = cameraComponent;
    Icarus.world.add(player);

    player.position = Vector2(icarus.size.x / 2, icarus.size.y / 2);

    cameraComponent.followDampened(player,
        snap: true,
        verticalOnly: true,
        acceleration: 20,
        maxDistance: icarus.size.y / 2,
        minDistance: 40);
  }

  Future<void> startLevel() async {
    var bg = BackgroundSprite();
    var prop = IcebergSprite();
    bg.position += Vector2(0, Icarus.viewportResolution.y);
    prop.position += Vector2(0, Icarus.viewportResolution.y);
    Icarus.world.add(bg);
    Icarus.world.add(prop);

    lastYpos = addPlatforms(0, 400, 7); // add the initial first 7 platforms

    GameManager.startLevel();
  }

  int addPlatforms(int lastYpos, int distanceBetween, int numberofPlatforms) {
    for (var i = 0; i < numberofPlatforms; i++) {
      var platform = Platform();
      Icarus.world.add(platform);
      platform.position = Vector2(
          Random().nextInt(Icarus.viewportResolution.x.toInt()).toDouble(),
          -lastYpos.toDouble());
      int moveChance = Random().nextInt(10);
      if (moveChance <= 2) {
        platform.isMoving = true;
        platform.speed = 15;
      } else if (moveChance <= 5) {
        platform.isMoving = true;
        platform.speed = 35;
      }
      lastYpos += distanceBetween;
      bool enemyAdded = false;
      int enemyChance = Random().nextInt(100);
      double enemyThreshold = -LevelManager.player.position.y / 1000;
      clampDouble(enemyThreshold, 0, 30);
      if (enemyChance <= enemyThreshold && !enemyAdded) {
        var enemy = Enemy();
        Icarus.world.add(enemy);
        enemy.position = Vector2(
            Random().nextInt(Icarus.viewportResolution.x.toInt()).toDouble(),
            -lastYpos.toDouble() - 200);
        enemy.isMoving = true;
        enemyAdded = true;
      }
    }

    return lastYpos;
  }

  static Color getBackgroundColor() {
    // Define the RGB values for the starting (light blue) and ending (orange) colors
    Color startColor = const Color(0xFFADD8E6); // Light blue
    Color endColor = const Color(0xFFFFA500); // Orange

    // Calculate the color gradient
    double gradientRatio = GameManager.height / GameManager.distanceToSun;
    int r = (startColor.red + (endColor.red - startColor.red) * gradientRatio)
        .round();
    int g =
        (startColor.green + (endColor.green - startColor.green) * gradientRatio)
            .round();
    int b =
        (startColor.blue + (endColor.blue - startColor.blue) * gradientRatio)
            .round();

    return Color.fromARGB(255, r, g, b);
  }
}
