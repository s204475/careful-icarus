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

  double velocity = 0;
  double acceleration = 0;

  @override
  void update(double dt) {
    
  }

  // for use in player controller
  // add a given newton force to the player
  void addForce(double force) {

  }
}