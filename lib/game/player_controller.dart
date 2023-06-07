import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

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
  // adds a player physics object as a child of this component
  PlayerObject player = PlayerObject();
  @override
  add(player);


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