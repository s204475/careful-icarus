import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

class PlayerObject extends SpriteComponent{
  PlayerObject({super.position, super.size, super.priority}) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    debugPrint("loading PlayerObject");
    sprite = await findGame()?.loadSprite('PixelPenguin1.png');

    sprite?.originalSize.x;
    sprite?.originalSize.y;
  }

  double mass = 1;
  Vector2 velocity = Vector2.zero();
  Vector2 acceleration = Vector2.zero();

  static const gravity = 9.834; // m/(s^2)

  @override
  void update(double dt) {
    /*
    debugPrint("update deltatime: $dt, position: $position, velocity $velocity, acceleration $acceleration.");
    velocity += acceleration*dt; // apply acceleration

    velocity.y -= gravity*dt; // apply gravity

    position += velocity*dt; // apply position
    */
  }

  // for use in player controller
  // add a given newton force to the player
  void addForce(int force, Vector2 direction) {
    
  }
}