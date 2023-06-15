import 'dart:math';

import 'package:careful_icarus/game/managers/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../controllers/player.dart';
import '../util/color_schemes.dart';

import '../icarus.dart';

class HealthBar extends PositionComponent with HasGameRef<Icarus> {
  @override
  void render(Canvas canvas) {
    final barWidth =
        gameRef.size.x; // Assuming the wax bar width matches the screen width
    const barHeight = 20.0;
    final barFillWidth =
        max(0, barWidth * (GameManager.waxCurrent / GameManager.waxMax))
            .toDouble(); // Assuming health is a percentage (0-100)

    // Draw the empty wax bar background
    final backgroundPaint = Paint()..color = Colors.grey;
    canvas.drawRect(Rect.fromLTWH(0, 0, barWidth, barHeight), backgroundPaint);

    // Draw the filled wax bar
    final fillPaint = Paint()..color = IcarusColors.waxColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, barFillWidth, barHeight), fillPaint);
  }

  @override
  void update(double dt) {
    position.y = Icarus.cameraComponent.visibleWorldRect.top + 100;
    GameManager.waxCurrent -=
        dt * 3; // wax is a countdown timer. 100 wax = 33 seconds to live
  }
}
