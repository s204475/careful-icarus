import 'dart:ui';
import 'package:careful_icarus/game/util/util.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../managers/game_manager.dart';
import 'player.dart';

const chanceForFish = 1;

class Platform extends SpriteComponent with HasGameRef {
  Platform({
    super.position,
  }) : super(anchor: Anchor.center, size: Vector2(150, 100), priority: 1);

  bool isAlive =
      true; // Indicates whether the object is alive or not (can be hit)
  bool hasFish = true; //Indicates whether Icarus can use it to jump higher

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(getCloudSprite(hasFish));

    await add(RectangleHitbox());
    debugMode = GameManager.debugging;
  }
}

String getCloudSprite(bool fish) {
  int rand = Util.nextInt(0, 3);
  switch (rand) {
    case 0:
      if (fish) return 'CloudFish1.png';
      return 'Cloud1.png';
    case 1:
      if (fish) return 'CloudFish2.png';
      return 'Cloud2.png';
    case 2:
      if (fish) return 'CloudFish3.png';
      return 'Cloud3.png';
    default:
      if (fish) return 'CloudFish1.png';
      return 'Cloud1.png';
  }
}
