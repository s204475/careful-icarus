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
import '../managers/sound_manager.dart';
import 'enemy.dart';
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
  final int deathVelocity = 800;
  bool manualControl = false;
  bool disableControls = true;
  bool startFall = false; //when hitting obstcale or running out of wax

  int sealionProtectionsUsed = 0;

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
    launch();
  }

  /// Handles horizontal movement
  void move(double movement) {
    _hAxisInput = 0;
    _hAxisInput += movement;
  }

  /// Whenever the player easts a fish, they accelerate upwards
  void jump() {
    if (startFall) return;
    var jumpStrength = GameManager.jumpStrength;
    if (disableControls) return;
    SoundManager.playSound('Jump.wav', 0.6);
    velocity.y -= jumpStrength;
    velocity.y = clampDouble(velocity.y, -(jumpStrength * 1.5), -jumpStrength);
  }

  /// The first jump of the game
  void launch() {
    SoundManager.playSound('Jump.wav', 0.6);
    velocity.y -= GameManager.launchStrength;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (disableControls) return false;

    _hAxisInput = 0;

    // Keyboard movement
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      move(-200); //int to speed up the movement
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      move(200); //int to speed up the movement
    }

    return true;
  }

  @override
  Future<void> update(double dt) async {
    if (disableControls) return;

    var jumpStrength = GameManager.jumpStrength;

    velocity.x = _hAxisInput;
    velocity.y += gravity;

    // check if player is out of bounds
    final double dashHorizontalCenter = size.x;
    var playerSize = size.x / 2;
    if ((position.x) < -(gameRef.size.x / 3)) {
      position.x = gameRef.size.x * 1.5 - playerSize;
    }
    if ((position.x + playerSize) > gameRef.size.x * 1.5) {
      position.x = -(gameRef.size.x / 3);
    }
    //Add magnetometer support for mobile, runs in separate thread to avoid lag
    if (!manualControl &&
        (Platform.isAndroid || Platform.isIOS) &&
        !GameManager.manualControl) {
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
    checkPlayerDeath();
  }

  void checkPlayerDeath() {
    //Check if player is falling or have reached the sun
    if (velocity.y >= deathVelocity) {
      GameManager.lose();
    } else if (position.y.abs() >= GameManager.distanceToSun) {
      GameManager.win();
    }

    //Check if run out of wax
    if (GameManager.waxCurrent <= 0) {
      defeated();
    }
  }

  void updatePosition(double dt) {
    position += velocity * dt;
  }

  /* Add magnetometer support for mobile, runs in separate thread to avoid lag, 
  due to it being based on magnetometer we need to introduce a offset to the value
  */
  num magnometerOffset = 0;
  Future<void> sensorListener() async {
    magnetometerEvents.listen(
      (MagnetometerEvent event) {
        if (magnometerOffset == 0) {
          magnometerOffset = event.x;
        } else {
          var magnetometerValue = event.x - magnometerOffset;
          if ((magnetometerValue.abs()) > gyroDeadZone) {
            if (magnetometerValue > gyroDeadZone) {
              move(magnetometerValue * gyroSensitivity);
            } else if (magnetometerValue < -gyroDeadZone) {
              move(magnetometerValue * gyroSensitivity);
            }
          } else {
            move(0);
          }
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
    if (other is Enemy && other.isAlive) {
      if (sealionProtectionsUsed < GameManager.sealprotection) {
        //Can use SealionProtection
        sealionProtectionsUsed++;
        other.destroy();
        jump();
      } else {
        velocity.y = 10; //not immediate stop
        defeated();
      }
    } else if (other is kplatform.Platform &&
        other.isAlive &&
        (other is! Warning)) {
      jump();
      GameManager.fishGatheredRun++;
      other.destroy();
    }
  }

  void defeated() {
    startFall = true;
  }
}
