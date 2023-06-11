import 'dart:async';
import 'dart:ffi';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'platform.dart';
import '../managers/game_manager.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../icarus.dart';

enum Collidables {
  platform,
  powerup,
}

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
  }) : super(anchor: Anchor.center, size: Vector2(200, 200), priority: 100);

  double _hAxisInput = 0;
  double gravity = 9;
  Vector2 Velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('PixelPenguin1.png');

    await add(CircleHitbox());
    debugMode = GameManager.debugging;
  }

  @override
  void update(double dt) {
    Velocity.x = _hAxisInput * 200;
    Velocity.y += gravity;

    final double dashHorizontalCenter = size.x / 2;

    if (position.x < dashHorizontalCenter) {
      position.x = gameRef.size.x - (dashHorizontalCenter);
    }
    if (position.x > gameRef.size.x - (dashHorizontalCenter)) {
      position.x = dashHorizontalCenter;
    }

    position += Velocity * dt;
    super.update(dt);

    if (GameManager.height < position.y) {
      GameManager.height = position.y; //height might be set differently
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      jump(); //TODO: remove this debug statement
    }

    return true;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    //print("collision with " + other.toString());
    if (other is Platform) {
      jump();
    }
  }

  void moveLeft() async {
    _hAxisInput = 0;
    print("Left");
    sprite = await gameRef
        .loadSprite('PixelPenguin2.png'); //TODO remove this debug statement
    _hAxisInput += -1;
  }

  void moveRight() async {
    _hAxisInput = 0;
    print("Right");
    sprite = await gameRef
        .loadSprite('PixelPenguin1.png'); //TODO remove this debug statement
    _hAxisInput += 1;
  }

  void jump() {
    print("Jump");
    Velocity.y = -600;
  }
}
