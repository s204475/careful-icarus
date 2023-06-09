import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

// main player
class PlayerControls extends SpriteGroupComponent with HasGameRef, KeyboardHandler, TapCallbacks, DragCallbacks, CollisionCallbacks{
  PlayerControls({
    super.position,
     
  }): super (anchor: Anchor.center, size: Vector2(200,200), priority: 1);

  double _hAxisInput = 0;
  Vector2 Velocity = Vector2.zero();


  @override
  Future<void> onLoad() async{
    await super.onLoad();

    //final sprite = await findGame()?.loadSprite("PixelPenguin1.png");
  }

  @override
  void update(double dt){
    Velocity.x = _hAxisInput;
    position += Velocity;
    super.update(dt);
    print(position);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed){
    _hAxisInput = 0;
    if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      moveLeft();
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      moveRight();
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      //Up();
    }
    return true;
  }

  void moveLeft(){
    _hAxisInput = -1;
  }
  void moveRight(){
    _hAxisInput = 1;
  }
}
