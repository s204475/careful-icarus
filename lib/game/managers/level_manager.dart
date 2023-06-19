// ignore_for_file: prefer_initializing_formals
// ignore_for_file: invalid_use_of_internal_member

import 'package:careful_icarus/game/icarus.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import '../DampenedCamera.dart';
import '../controllers/enemy.dart';
import '../sprites/heads_up_display.dart';
import '../overlays/healthbar.dart';
import 'game_manager.dart';
import '../controllers/player.dart';
import '../controllers/platform.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import '../sprites/background.dart';
import '../util/util.dart';

/// Handles creation of the actual level, including the player, platforms, and background.
/// Also handles game over and winning logic
class LevelManager extends Component with HasGameRef<Icarus> {
  static late Player player;
  late CameraComponent cameraComponent;
  late HeightCounter scoreCounter;
  int lastYpos = 0;

  LevelManager(Icarus icarus, DampenedCamera cameraComponent) {
    player = Player();

    this.cameraComponent = cameraComponent;
    Icarus.world.add(player);

    player.position = Vector2(
        cameraComponent.viewfinder.visibleWorldRect.size.width / 4,
        cameraComponent.viewfinder.visibleWorldRect.size.height / 4);

    cameraComponent.followDampened(player,
        snap: true,
        verticalOnly: true,
        maxDistance: icarus.size.y / 2,
        minDistance: 100);

    // UI
    scoreCounter = HeightCounter(
        anchor: Anchor.topCenter,
        position: Vector2(
            cameraComponent.viewfinder.visibleWorldRect.size.width / 4, 40));
    Icarus.cameraComponent.viewport.add(scoreCounter);
  }

  Future<void> startLevel() async {
    //Initialise background and iceberg sprites
    var bg = BackgroundSprite();
    var prop = IcebergSprite();
    bg.position += Vector2(-(bg.size.x / 4), Icarus.viewportResolution.y * 1.5);
    prop.position += Vector2(
        -Icarus.viewportResolution.x / 2, Icarus.viewportResolution.y * 1.5);
    Icarus.world.addAll([bg, prop]);

    //Add fishing penguin if unlocked
    var fisher = FishingPenguin();
    fisher.position = Vector2(
        Icarus.viewportResolution.x / 4, Icarus.viewportResolution.y / 2);

    //Add wax (health) bag
    HealthBar healthbar = HealthBar();
    Icarus.world.add(healthbar);

    lastYpos = addPlatforms(0); // add the initial first 10 platforms

    GameManager.startLevel();
  }

  /// Adds a number of platforms to the level depending on the last (now destroyed) platform's position
  int addPlatforms(int lastYpos) {
    int numberofPlatforms = 10; // number of platforms to add
    for (var i = 0; i < numberofPlatforms; i++) {
      var platform = Platform();
      Icarus.world.add(platform);
      int km = (Random().nextInt(275) + 75); // distance between platforms
      platform.position = Vector2(
          Random()
                  .nextInt(Icarus.viewportResolution.x.toInt() + 200)
                  .toDouble() -
              100,
          -lastYpos.toDouble());
      int moveChance = Random().nextInt(10);
      if (moveChance <= 2) {
        platform.isMoving = true;
        platform.speed = 15;
      } else if (moveChance <= 5) {
        // chance of platform moving
        platform.isMoving = true;
        platform.speed = 35;
      }
      lastYpos += km;
      //Possibly adds an enemy
      bool enemyAdded = false;
      int enemyChance = Random().nextInt(100);
      double enemyThreshold = -LevelManager.player.position.y / 1000;
      enemyThreshold = clampDouble(enemyThreshold, 0,
          25); //The higher you are, the more likely you are to encounter an enemy. Max 25%
      if (enemyChance <= enemyThreshold && !enemyAdded) {
        var enemy = Enemy();
        Icarus.world.add(enemy);
        enemy.position = Vector2(
            Random().nextInt(Icarus.viewportResolution.x.toInt()).toDouble(),
            -lastYpos.toDouble() - 400);
        enemy.isMoving = true;
        enemyAdded = true;
      }
    }

    return lastYpos;
  }
}
