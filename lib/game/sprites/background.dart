import 'package:careful_icarus/game/managers/game_manager.dart';
import 'package:flame/components.dart';

import '../icarus.dart';

class BackgroundSprite extends SpriteComponent with HasGameRef<Icarus> {
  BackgroundSprite({
    super.position,
  }) : super(
            anchor: Anchor.bottomLeft,
            size: Vector2(Icarus.viewportResolution.x + 20,
                40000), //should be GameManager.distanceToSun.toDouble()
            priority: 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position -= Vector2(5, 0); //offset to make sure the background is visible

    sprite = await gameRef.loadSprite('BackgroundNew.png');
  }
}
