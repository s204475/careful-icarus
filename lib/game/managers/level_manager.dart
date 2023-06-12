import 'package:careful_icarus/game/icarus.dart';
import 'package:flame/cache.dart';
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
import '../sprites/background.dart';

class LevelManager extends Component with HasGameRef<Icarus> {
  var player;

  LevelManager(Icarus icarus, DampenedCamera cameraComponent) {
    player = Player();
    Icarus.world.add(player);

    player.position = Vector2(icarus.size.x / 2, icarus.size.y / 2);

    cameraComponent.followDampened(player,
        snap: true,
        verticalOnly: true,
        acceleration: 20,
        maxDistance: icarus.size.y / 2,
        minDistance: 40);
  }

  Future<void> StartLevel() async {
    var background = BackgroundSprite();
    Icarus.world.add(background);

    GameManager.StartLevel();
    addPlatforms(400, 100);
    player.jump(); //An initial jump
  }

  void addPlatforms(int distanceBetween, int numberofPlatforms) {
    int lastYpos = 0;
    for (var i = 0; i < numberofPlatforms; i++) {
      var platform = Platform();
      Icarus.world.add(platform);
      platform.position = Vector2(
          Random().nextInt(Icarus.viewportResolution.x.toInt()).toDouble(),
          -lastYpos.toDouble());
      lastYpos += distanceBetween;
    }
  }

  static Color getBackgroundColor() {
    // Define the RGB values for the starting (light blue) and ending (orange) colors
    Color startColor = Color(0xFFADD8E6); // Light blue
    Color endColor = Color(0xFFFFA500); // Orange

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
