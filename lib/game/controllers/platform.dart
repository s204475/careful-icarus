import 'dart:ui';
import 'package:careful_icarus/game/icarus.dart';
import 'package:careful_icarus/game/util/util.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';
import '../managers/game_manager.dart';
import '../managers/level_manager.dart';
import 'player.dart';

const chanceForFish = 1;

class Platform extends SpriteComponent with HasGameRef<Icarus> {
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

    await add(CircleHitbox());
    debugMode = GameManager.debugging;
  }

  void destroy() async {
    isAlive = false;
    var pfD = PlatformDissappearing();
    Icarus.world.add(pfD);
    removeFromParent();
  }
}

class PlatformDissappearing extends SpriteAnimationComponent with HasGameRef {
  PlatformDissappearing({
    super.position,
  }) : super(anchor: Anchor.center, size: Vector2(150, 100), priority: 1);

  late double spriteSheetWidth = 200, spriteSheetHeight = 150;

  late SpriteAnimation cloudAnimation;

  @override
  Future<void> onLoad() async {
    var spriteImages = await Flame.images.load(
        'CloudDissappear-Sheet.png'); //Should be loaded in at game start, not on collision

    final spriteSheet = SpriteSheet(
        image: spriteImages,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    size = Vector2(spriteSheetWidth, spriteSheetHeight);

    animation = spriteSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: 5, loop: false);

    Future.delayed(const Duration(milliseconds: 500), () {
      removeFromParent();
    });
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
