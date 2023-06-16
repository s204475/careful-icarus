import 'package:careful_icarus/game/controllers/enemy.dart';
import 'package:careful_icarus/game/controllers/platform.dart';
import 'package:careful_icarus/game/controllers/player.dart';
import 'package:careful_icarus/game/controllers/warning.dart';
import 'package:careful_icarus/game/icarus.dart';
import 'package:careful_icarus/game/managers/level_manager.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('A destroyed platform spawns a SpriteAnimationComponent', () {
    // Create a new Enemy instance
    Icarus icarus =
        Icarus(viewportResolution: Vector2(100, 100), notifyParent: () {});
    Icarus.world = World();
    Platform platform = Platform(position: Vector2.zero());
    Player player = Player(position: Vector2(0, -2001));
    LevelManager.player = player;
    Icarus.world.add(platform);
    Icarus.world.add(player);

    expect(
        Icarus.world.children
            .any((element) => element is PlatformDissappearing),
        false); //Platform exists

    platform.checkIfBelow();

    expect(
        Icarus.world.children
            .any((element) => element is PlatformDissappearing),
        true); //Platform has been removed
  });

  test('Platforms much below the player should be destroyed', () {
    // Create a new Enemy instance
    Icarus icarus =
        Icarus(viewportResolution: Vector2(100, 100), notifyParent: () {});
    Platform platform = Platform(position: Vector2.zero());
    Player player = Player(position: Vector2(0, -2001));
    LevelManager.player = player;
    Icarus.world.add(platform);
    Icarus.world.add(player);

    expect(Icarus.world.children.contains(platform), true); //Platform exists

    platform.checkIfBelow();

    expect(Icarus.world.children.contains(platform),
        false); //Platform has been removed
  });
}
