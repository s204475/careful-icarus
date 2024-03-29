// ignore_for_file: prefer_initializing_formals
import 'dart:io';
import 'package:careful_icarus/game/managers/sound_manager.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'DampenedCamera.dart';
import 'package:flame/events.dart';
import 'controllers/player.dart';
import 'managers/game_manager.dart';
import 'managers/level_manager.dart';
import 'dart:math';

enum Character { penguin }

/// The main game class. Initialises the game and creates the @level_manager.
class Icarus extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final Function() notifyParent;

  Icarus({required Vector2 viewportResolution, required this.notifyParent}) {
    Icarus.viewportResolution = viewportResolution;
  }
  static late Vector2 viewportResolution;
  static late DampenedCamera cameraComponent;
  static late final World world;
  late LevelManager levelManager;
  int lastPlatformYpos = 0;
  static bool pause = false;

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    world = World();
    cameraComponent = DampenedCamera(
      world: world,
    );

    //Load audio into cache to smoothe playback
    if (Platform.isAndroid || Platform.isIOS) {
      await FlameAudio.audioCache
          .loadAll(['Jump.wav', 'FlyingPenguins_Theme.mp3']);
    }

    addAll([world, cameraComponent]);
    levelManager = LevelManager(this, cameraComponent);
    await levelManager.startLevel();
    lastPlatformYpos = levelManager.lastYpos;

    add(TapTarget(LevelManager.player));
  }

  @override
  Future<void> update(double dt) async {
    // add platforms if needed, 10 at a time
    if (LevelManager.player.position.y < (-lastPlatformYpos + 1000)) {
      //When 1000 pixels close to the last platform, add more platforms
      lastPlatformYpos = levelManager.addPlatforms(lastPlatformYpos);
    }
    togglePause();
    super.update(dt);
  }

  togglePause() {
    if (pause) {
      pauseEngine();
      if (GameManager.gameover) {
        notifyParent();
        garbageCollect();
        removeFromParent();
      }
    } else {
      resumeEngine();
    }
  }

  garbageCollect() {
    remove(world);
  }
}

/// A simple component that responds when the user taps the screen. Can be used to move the player left or right.
class TapTarget extends PositionComponent with TapCallbacks {
  late Player player;
  bool _fingerOnScreen = false;
  double _xLocation = 0;
  bool started = false;

  /// A constructor that initialises $TapTarget with a reference to the player
  TapTarget(this.player);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    // Adjust the size of the TapTarget to cover the whole screen
    this.size = size;

    // Center the TapTarget on the screen
    position = size / 2 - this.size / 2;
  }

  /// Start moving depending on the side of touch
  @override
  void onTapDown(TapDownEvent event) {
    if (!started) {
      player.start();
      started = true;
      return;
    }
    if (!GameManager.manualControl) {
      return;
    }
    player.manualControl = true;
    _fingerOnScreen = true;
    _xLocation = event.localPosition.x;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_fingerOnScreen) {
      if (_xLocation < Icarus.viewportResolution.x / 2) {
        player.move(-200.toDouble());
      } else {
        player.move(200.toDouble());
      }
    }
  }

  /// Stop moving when the user lifts their finger
  @override
  void onTapUp(TapUpEvent event) {
    player.manualControl = false;
    _fingerOnScreen = false;
  }
}
