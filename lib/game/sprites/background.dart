import 'package:careful_icarus/game/managers/game_manager.dart';
import 'package:flame/components.dart';

import '../icarus.dart';

class BackgroundSprite extends SpriteComponent with HasGameRef<Icarus> {
  BackgroundSprite({
    super.position,
  }) : super(
            anchor: Anchor.bottomLeft,
            size: Vector2(Icarus.viewportResolution.x,
                30000), //should be GameManager.distanceToSun.toDouble()
            priority: 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('BackgroundNew.png');
  }
}
