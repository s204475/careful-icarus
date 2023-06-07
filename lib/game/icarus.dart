import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'player_controller.dart';

// game main function
class Icarus extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    print("loading Game");
    addAll([PlayerControls()]);
  }
}
