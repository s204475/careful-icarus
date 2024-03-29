import 'package:careful_icarus/game/managers/game_manager.dart';
import 'package:flame/components.dart';

import '../icarus.dart';

class BackgroundSprite extends SpriteComponent with HasGameRef<Icarus> {
  BackgroundSprite({
    super.position,
  }) : super(
            anchor: Anchor.bottomLeft,
            size: Vector2(Icarus.viewportResolution.x * 2 + 20,
                GameManager.distanceToSun.toDouble()),
            priority: 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position -= Vector2(5, 0); //offset to make sure the background is visible

    sprite = await gameRef.loadSprite('BackgroundNew.png');
  }
}

class FishingPenguin extends SpriteComponent with HasGameRef<Icarus> {
  FishingPenguin({
    super.position,
  }) : super(anchor: Anchor.bottomLeft, priority: 1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('FishingPenguin.png');
  }
}

class IcebergSprite extends SpriteComponent with HasGameRef<Icarus> {
  IcebergSprite({
    super.position,
  }) : super(
            anchor: Anchor.bottomLeft,
            size: Vector2(Icarus.viewportResolution.x * 2,
                Icarus.viewportResolution.y * 2),
            priority: 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('Start2.png');
  }
}
