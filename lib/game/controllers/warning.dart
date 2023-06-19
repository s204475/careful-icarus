import '../icarus.dart';
import 'platform.dart';

/// Warning is a sprite that appears below the enemy on top of the screen, so the player can see it coming
class Warning extends Platform {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite("Warning.png");
  }

  @override
  void destroy() async {
    isAlive = false;
    removeFromParent();
  }
}
