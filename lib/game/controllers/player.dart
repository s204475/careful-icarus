import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:careful_icarus/game/DampenedCamera.dart';
import 'package:careful_icarus/game/controllers/warning.dart';
import 'package:careful_icarus/game/managers/level_manager.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../icarus.dart';
import '../managers/sound_manager.dart';
import 'enemy.dart';
import '../sprites/glider.dart';
import 'platform.dart' as kplatform;
import '../managers/game_manager.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flame_audio/flame_audio.dart';

enum Collidables {
  platform,
  powerup,
}

/// The main player component. Handles all player input and movement
class Player extends SpriteComponent
    with
        HasGameRef<Icarus>,
        KeyboardHandler,
        TapCallbacks,
        DragCallbacks,
        CollisionCallbacks {
  Player({
    super.position,
  }) : super(anchor: Anchor.center, size: Vector2(152, 73), priority: 100);

  double _hAxisInput = 0;
  final double gravity = 9;
  Vector2 velocity = Vector2.zero();
  final double gyroDeadZone = 1.5;
  final double gyroSensitivity = 10;
  final double maxHorizontalVelocity = 10;
  final double maxVerticalVelocity = 10;
  final int deathVelocity = 1000;
  bool manualControl = false;
  bool disableControls = true;

  bool usedSealProtection = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('PixelPenguin5.png');
    position -= Vector2(0, 15); // moved more up

    await add(CircleHitbox());
    debugMode = GameManager.debugging;
  }

  void start() async {
    disableControls = false;
    jump();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (disableControls) return false;

    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      move(-200); //int to speed up the movement
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      move(200); //int to speed up the movement
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      jump(); //TODO: remove this debug "cheat"
    }

    return true;
  }

  void move(double movement) {
    _hAxisInput = 0;
    _hAxisInput += movement;
  }

  void jump() {
    var jumpStrength = GameManager.jumpStrength;
    if (disableControls) return;
    SoundManager.playSound('sfx_wing.mp3', 0.6);
    velocity.y -= jumpStrength;
    velocity.y = clampDouble(velocity.y, -(jumpStrength * 2), -jumpStrength);
  }

  @override
  Future<void> update(double dt) async {
    if (disableControls) return;

    var jumpStrength = GameManager.jumpStrength;

    velocity.x = _hAxisInput;
    velocity.y += gravity;

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
    if (!manualControl && (Platform.isAndroid || Platform.isIOS)) {
      sensorListener();
    }

    //Update position based on player input or use of magnetometer
    updatePosition(dt);
    super.update(dt);

    //Update sprite based on direction of movement
    if (velocity.y < -50) {
      //up
      sprite = await gameRef.loadSprite('Up.png');
    } else if (velocity.y > 50) {
      //down
      sprite = await gameRef.loadSprite('Down.png');
    } else {
      sprite = await gameRef.loadSprite('Default.png');
    }

    //Update the run's maximum height reached
    if (GameManager.height < position.y) {
      GameManager.height = position.y; //height might be set differently
    }

    //Check win or lose conditions
    if (checkPlayerDeath()) {
      GameManager.lose();
    } else if (position.y.abs() >= GameManager.distanceToSun) {
      GameManager.win();
    }

    // update the camera:
    DampenedCamera.fixedUpdated(dt, velocity);
  }

  bool checkPlayerDeath() => velocity.y >= deathVelocity;

  void updatePosition(double dt) {
    position += velocity * dt;
  }

  Future<void> sensorListener() async {
    double? magnometerValue;
    magnetometerEvents.listen(
      (MagnetometerEvent event) {
        if ((event.x.abs()) > gyroDeadZone) {
          if (event.x > gyroDeadZone) {
            move(event.x * gyroSensitivity);
          } else if (event.x < -gyroDeadZone) {
            move(event.x * gyroSensitivity);
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
    if (other is Enemy && other.isAlive) {
      if (GameManager.sealprotection && !usedSealProtection) {
        //Can use SealProtection once
        debugPrint("SealProtection used");
        usedSealProtection = true;
        other.destroy();
        jump();
      } else {
        GameManager.lose();
      }
    } else if (other is kplatform.Platform &&
        other.isAlive &&
        (other is! Warning)) {
      jump();
      GameManager.fishGatheredRun++;
      other.destroy();
    }
  }
}
