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
  double gyroDeadZone = 1.5;
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
    print("Jump");
    Velocity.y = -600;
  }

  @override
  Future<void> update(double dt) async {
    Velocity.x = _hAxisInput;
    Velocity.y += gravity;

    final double dashHorizontalCenter = size.x / 2;

    if ((position.x + 100 ) < dashHorizontalCenter) {
      position.x = gameRef.size.x - (dashHorizontalCenter);
    }
    if ((position.x - 100 ) > gameRef.size.x - (dashHorizontalCenter)) {
      position.x = dashHorizontalCenter;
    }
    sensorListener();
    
    updatePosition(dt);
    super.update(dt);
  }

  void updatePosition(double dt) {
    //clampDouble(Velocity.x, -maxHorizontalVelocity, maxHorizontalVelocity);
    //clampDouble(Velocity.y, -maxVerticalVelocity, maxVerticalVelocity);
    position += Velocity * dt;
    //_hAxisInput = 0;
    //print(position);
  }
  Future<void> sensorListener() async{
    double? magnometerValue;
    magnetometerEvents.listen(
      (MagnetometerEvent event) {
        //print("event.x: ${event.x}");
        if((event.x.abs()) > gyroDeadZone){
          //print("got here!");
          if(event.x > gyroDeadZone){
            move(event.x*4);
          } else if(event.x < -gyroDeadZone){
            move(event.x*4);
          } 
        } else{
          move(0);
        }

      },
      onError: (error) {
        // Logic to handle error in case sensor is not available
      },
      cancelOnError: true,
    );
    //print(magnometerValue);
  }
}
