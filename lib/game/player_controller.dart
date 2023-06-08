import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';

import 'player_character.dart';

// main player physics object
class PlayerObject extends BodyComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite('sprites/PixelPenguin1.png');
    debugPrint("loading playerBody");

    renderBody = false;
    add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2(2,2),
        anchor: Anchor.center,
      ),
    );
  }


  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      userData: this,
      position: Vector2.zero(),
      fixedRotation: true
    );
    return world.createBody(bodyDef);
  }
}

// main player
class PlayerControls extends PositionComponent with TapCallbacks, DragCallbacks {
  PlayerControls() : super(anchor: Anchor.center);

  // adds a player physics object as a child of this component
  var player = PlayerObject();
  
  @override
  void onLoad() {
    debugPrint("loading playerControls");
    // adds a player physics object as a child of this component
    addAll([player]);
    
  }



  @override
  void onTapUp(TapUpEvent event) {
    // to use an item
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    // setup UI to switch between items

    // start drag by saving the current position that is interacted
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