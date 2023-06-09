import 'dart:async';
import 'dart:ffi';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../icarus.dart';

// main player
class Player extends SpriteComponent
    with
        HasGameRef,
        KeyboardHandler,
        TapCallbacks,
        DragCallbacks,
        CollisionCallbacks {
  Player({
    super.position,
  }) : super(anchor: Anchor.center, size: Vector2(200, 200), priority: 1);

  double _hAxisInput = 0;
  double gravity = 0;
  Vector2 Velocity = Vector2.zero();
  double gyroDeadZone = 0.5;
  int hSpeed = 200;
  double maxHorizontalVelocity = 10;
  double maxVerticalVelocity = 10;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('Default.png');

    await add(CircleHitbox());
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      move(-1);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      move(1);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      jump(); //TODO: remove this debug statement
    }

    return true;
  }

  void move(int movement) {
    _hAxisInput = 0;
    _hAxisInput += movement;
  }

  void jump() {
    print("Jump");
    Velocity.y = -600;
  }

  @override
  void update(double dt) {
    Velocity.x = _hAxisInput * hSpeed;
    Velocity.y += gravity;

    final double dashHorizontalCenter = size.x / 2;

    if (position.x < dashHorizontalCenter) {
      position.x = gameRef.size.x - (dashHorizontalCenter);
    }
    if (position.x > gameRef.size.x - (dashHorizontalCenter)) {
      position.x = dashHorizontalCenter;
    }
    updatePosition(dt);
    super.update(dt);

    /*
      Controls using Gyroscope
      GyroscopeEvent generates the triple: 
      (x: float, y: float, z: float) 
      Only y is needed for controls. Rotates between -2 and 2
      3 levels of momemtum gain based on rotation:
      0.5 = 1
      0.75-1 = 2
      >1 = 3
    */
    gyroscopeEvents.listen(
      (GyroscopeEvent event) {
        if (event.y.abs() >= gyroDeadZone) {
          int direction = event.y > 0 ? 1 : -1;
          if (event.y < 0.75) {
            move(1 * direction);
          } else if (event.y < 1) {
            move(1 * direction);
          } else {
            move(1 * direction);
          }
        }
      },
      onError: (error) {
        // Logic to handle error in case sensor is not available
      },
      cancelOnError: true,
    );
  }

  void updatePosition(double dt) {
    clampDouble(Velocity.x, -maxHorizontalVelocity, maxHorizontalVelocity);
    clampDouble(Velocity.y, -maxVerticalVelocity, maxVerticalVelocity);
    position += Velocity * dt;
    _hAxisInput = 0;
    print(position);
  }
}
