import 'dart:async';
import 'dart:ffi';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../game/icarus.dart';

// main player
class PlayerControls extends SpriteComponent with HasGameRef, KeyboardHandler, TapCallbacks, DragCallbacks, CollisionCallbacks{
  PlayerControls({
    super.position,
  }): super (anchor: Anchor.center, size: Vector2(200,200), priority: 1);

  double _hAxisInput = 0;
  Vector2 Velocity = Vector2.zero();

  @override
  Future<void> onLoad() async{
    await super.onLoad();

    sprite = await gameRef.loadSprite('PixelPenguin1.png');
  }

  @override
  void update(double dt){
    Velocity.x = _hAxisInput * 200;
    Velocity.y = 0;

    final double dashHorizontalCenter = size.x / 2;

    if (position.x < dashHorizontalCenter) {
      position.x = gameRef.size.x - (dashHorizontalCenter);
    }
    if (position.x > gameRef.size.x - (dashHorizontalCenter)) {
      position.x = dashHorizontalCenter;
    }

    position += Velocity * dt;
    super.update(dt);
    print(position);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      //jump(); //TODO: remove this debug statement
    }

    return true;
  }

  void moveLeft(){
    _hAxisInput = 0;
      print("Left");
    _hAxisInput += -1;
  }
  void moveRight(){
    _hAxisInput = 0;
    print("Right");
    _hAxisInput += 1;
  }
}
