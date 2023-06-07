import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';

import 'package:sensors_plus/sensors_plus.dart';

// the sprite of the player
class PlayerSprite extends SpriteComponent {

}

// main player physics object
class PlayerObject extends BodyComponent {
  @override
  Body createBody() {
  final bodyDef = BodyDef(
      type: BodyType.static,
      userData: this,
      position: Vector2.zero(),
      fixedRotation: true
    );
    throw world.createBody(bodyDef);
  }
}

// main player
class PlayerControls extends PositionComponent with TapCallbacks, DragCallbacks {
PlayerControls() : super();

  // adds a player physics object as a child of this component
  var player = PlayerObject();
  // adds the player sprite
  var playerSprite = PlayerSprite();
  
  void onLoad() {
    // adds a player physics object as a child of this component
    addAll([player, playerSprite]);
  }



  @override
  void onTapUp(TapUpEvent event) {
    // to use an item
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    // setup UI to switch between items
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // switch to next item
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    // select current item
  }
}