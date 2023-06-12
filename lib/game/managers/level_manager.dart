import 'package:careful_icarus/game/icarus.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import '../DampenedCamera.dart';
import 'game_manager.dart';
import '../controllers/player.dart';
import '../controllers/platform.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

class LevelManager extends Component with HasGameRef<Icarus> {
  var player;
  var icarus; //rename to game?

  LevelManager(Icarus icarus, DampenedCamera cameraComponent) {
    player = Player();
    this.icarus = icarus;
    Icarus.world.add(player);

    player.position = Vector2(icarus.size.x / 2, icarus.size.y / 2);

    cameraComponent.followDampened(player, snap: true, verticalOnly: true,
      acceleration: 20,
      maxDistance: icarus.size.y / 2, 
      minDistance: 40);
  }

  void StartLevel() {
    //var platform = Platform();
    //icarus.add(platform); //Adds a platform at the bottom of the screen
    //platform.position = Vector2(icarus.size.x / 2, icarus.size.y - 5);

    addPlatforms(400, 100);
  }

  void addPlatforms(int distanceBetween, int numberofPlatforms) {
    int lastYpos = 0;
    for (var i = 0; i < numberofPlatforms; i++) {
      var platform = Platform();
      Icarus.world.add(platform);
      platform.position = Vector2(
          Random().nextInt(icarus.size.x.toInt()).toDouble(),
          -lastYpos.toDouble());
      lastYpos += distanceBetween;
    }
  }
}
