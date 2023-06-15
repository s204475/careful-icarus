import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import '../managers/game_manager.dart';

Vector2 platformSize = Vector2(152, 73);

/// Not used in the game, but can be used to create a glider animation
class GliderAnimation extends SpriteAnimationComponent with HasGameRef {
  GliderAnimation({
    super.position,
  }) : super(anchor: Anchor.center, size: platformSize, priority: 200);

  late double spriteSheetWidth = 304, spriteSheetHeight = 135;

  late SpriteAnimation gliderAnimation;

  @override
  Future<void> onLoad() async {
    var spriteImages = await Flame.images.load(
        'PixelPenguin-Sheet.png'); //Should be loaded in at game start, not on collision

    final spriteSheet = SpriteSheet(
        image: spriteImages,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    animation = spriteSheet.createAnimation(
        row: 0, stepTime: 0.3, from: 0, to: 4, loop: false);

    debugMode = GameManager.debugging;

    Future.delayed(const Duration(milliseconds: 2000), () {
      removeFromParent();
    });
  }
}
