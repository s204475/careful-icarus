import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:careful_icarus/game/DampenedCamera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../icarus.dart';
import 'platform.dart' as kplatform;
import '../managers/game_manager.dart';
import 'package:sensors_plus/sensors_plus.dart';

enum Collidables {
  platform,
  powerup,
}

/// The main player component. Handles all player input and movement
class Player extends SpriteComponent
    with
        HasGameRef,
        KeyboardHandler,
        TapCallbacks,
        DragCallbacks,
        CollisionCallbacks {
  Player({
    super.position,
  }) : super(anchor: Anchor.center, size: Vector2(152, 73), priority: 100);

  double _hAxisInput = 0;
  double gravity = 9;
  Vector2 Velocity = Vector2.zero();
  double gyroDeadZone = 1.5;
  double maxHorizontalVelocity = 10;
  double maxVerticalVelocity = 10;
  int deathVelocity = 800;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('Default.png');

    await add(CircleHitbox());
    debugMode = GameManager.debugging;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      move(-200); //int to speed up the movement
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      move(200); //int to speed up the movement
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      jump(); //TODO: remove this debug statement
    }

    return true;
  }

  void move(double movement) {
    _hAxisInput = 0;
    _hAxisInput += movement;
  }

  void jump() {
    //print("Jump");
    Velocity.y -= 600;
    Velocity.y = clampDouble(Velocity.y, -1000, -600);
  }

  @override
  Future<void> update(double dt) async {
    Velocity.x = _hAxisInput;
    Velocity.y += gravity;

    // check if player is out of bounds
    final double dashHorizontalCenter = size.x / 2;
    var playerSize = size.x / 2;
    if ((position.x + playerSize) < dashHorizontalCenter) {
      position.x = gameRef.size.x - (dashHorizontalCenter) + playerSize;
    }
    if ((position.x - playerSize) > gameRef.size.x - (dashHorizontalCenter)) {
      position.x = dashHorizontalCenter - playerSize;
    }
    //Add magnetometer support for mobile, runs in separate thread to avoid lag
    if (Platform.isAndroid || Platform.isIOS) {
      sensorListener();
    }

    updatePosition(dt);
    super.update(dt);

    if (Velocity.y < -50) {
      //up
      sprite = await gameRef.loadSprite('Up.png');
    } else if (Velocity.y > 50) {
      //down
      sprite = await gameRef.loadSprite('Down.png');
    } else {
      sprite = await gameRef.loadSprite('Default.png');
    }

    // check if player is dead
    checkPlayerDeath();

    // check player win
    if (position.y.abs() + 100 > GameManager.distanceToSun) {
      debugPrint("You Win!");
    }

    if (GameManager.height < position.y) {
      GameManager.height = position.y; //height might be set differently
    }

    // update the camera:
    DampenedCamera.fixedUpdated(dt);
  }

  void updatePosition(double dt) {
    position += Velocity * dt;
  }

  Future<void> sensorListener() async {
    double? magnometerValue;
    magnetometerEvents.listen(
      (MagnetometerEvent event) {
        if ((event.x.abs()) > gyroDeadZone) {
          if (event.x > gyroDeadZone) {
            move(event.x * 6);
          } else if (event.x < -gyroDeadZone) {
            move(event.x * 6);
          }
        } else {
          move(0);
        }
      },
      onError: (error) {
        // Logic to handle error in case sensor is not available
      },
      cancelOnError: true,
    );
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    //print("collision with " + other.toString());
    if (other is kplatform.Platform && other.isAlive) {
      jump();
      other.destroy();
    }
  }

  bool checkPlayerDeath() {
    if (Velocity.y >= deathVelocity) {
      debugPrint("Game Over");
      return true;
    }
    return false;
  }
}
