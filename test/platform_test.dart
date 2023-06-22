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
        false); //Is there a PlatformDissappearing component?

    platform.checkIfBelow(); //Destroys platform if below player

    expect(
        Icarus.world.children
            .any((element) => element is PlatformDissappearing),
        true); //Platform has been removed and there should be a PlatformDissappearing component
  });

  test('Platforms much below the player should be destroyed', () {
    // Initialize the game
    Icarus icarus =
        Icarus(viewportResolution: Vector2(100, 100), notifyParent: () {});
    Player player = Player(position: Vector2(0, -2001));
    LevelManager.player = player;
    // Create a new Platform instance
    Platform platform = Platform(position: Vector2.zero());
    Icarus.world.add(platform);
    Icarus.world.add(player);

    expect(Icarus.world.children.contains(platform), true); //Platform exists

    platform.checkIfBelow(); //Destroys platform if below player

    expect(Icarus.world.children.contains(platform),
        false); //Platform has been removed
  });
}
