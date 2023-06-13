import '../icarus.dart';
import 'platform.dart';

class Warning extends Platform {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite("PixelPenguin3.png");
  }

  @override
  void destroy() async {
    isAlive = false;
    removeFromParent();
  }
}
