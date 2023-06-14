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
import 'package:flutter/services.dart';
import '../icarus.dart';
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
  Vector2 Velocity = Vector2.zero();
  final double gyroDeadZone = 1.5;
  final double gyroSensitivity = 10;
  final double maxHorizontalVelocity = 10;
  final double maxVerticalVelocity = 10;
  final int deathVelocity = 800;
  bool manualControl = false;
  bool disableControls = true;

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
    if (disableControls) return;
    //print("Jump");
    FlameAudio.play('sfx_wing.mp3');
    Velocity.y -= 600;
    Velocity.y = clampDouble(Velocity.y, -1000, -600);
  }

  @override
  Future<void> update(double dt) async {
    if (disableControls) return;

    Velocity.x = _hAxisInput;
    Velocity.y += gravity;

    // check if player is out of bounds
    final double dashHorizontalCenter = size.x;
    var playerSize = size.x / 2;
    if ((position.x) < -(gameRef.size.x/3)) {
      
      position.x = gameRef.size.x*1.5 - playerSize;
    }
    if ((position.x + playerSize) > gameRef.size.x*1.5 ) {
      position.x = -(gameRef.size.x/3);
    }
    //Add magnetometer support for mobile, runs in separate thread to avoid lag
    if (!manualControl && (Platform.isAndroid || Platform.isIOS)) {
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

    if (GameManager.height < position.y) {
      GameManager.height = position.y; //height might be set differently
    }

    //Check win or lose conditions
    if (checkPlayerDeath()) {
      GameManager.lose();
    } else if (position.y.abs() >= GameManager.distanceToSun) {
      GameManager.win();
    }
  }

  bool checkPlayerDeath() => Velocity.y >= deathVelocity;

  void updatePosition(double dt) {
    position += Velocity * dt;
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
      GameManager.lose();
    } else if (other is kplatform.Platform &&
        other.isAlive &&
        !(other is Warning)) {
      jump();
      GameManager.fishGathered++;
      other.destroy();
    }
  }
}
