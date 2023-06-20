import 'package:careful_icarus/game/controllers/player.dart';
import 'package:careful_icarus/game/icarus.dart';
import 'package:careful_icarus/game/managers/level_manager.dart';
import 'package:careful_icarus/game/managers/sound_manager.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/extensions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Icarus icarus =
      Icarus(viewportResolution: Vector2(1000, 1500), notifyParent: () {});
  SoundManager.muted = true;

  testWithFlameGame('the name of the test', (icarus) async {
    await icarus.ready();
    WidgetsFlutterBinding.ensureInitialized();
    SoundManager.muted = true;

    Player player = Player();
    Icarus.world = World();
    Icarus.world.add(player);

    player.start();

    for (int i = 0; i < 100; i++) {
      //Simulate 100 frames
      player.velocity.y += player.gravity;
      player.updatePosition(0.1);
      if (i < 83) {
        //After launching, the player should be moving upwards for 83 frames
        expect(player.velocity.y, lessThan(0));
      } else {
        expect(
            player.velocity.y,
            greaterThan(
                0)); //After 83 frames, gravity should have stopped the players upward momentum
      }
    }
  });
}
