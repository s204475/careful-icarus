import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

class PlayerObject extends SpriteComponent{
  PlayerObject({super.position, super.size, super.priority}) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    debugPrint("loading PlayerObject");
    sprite = await findGame()?.loadSprite('PixelPenguin1.png');
  }

  @override
  void update(double dt) {
    
  }
}