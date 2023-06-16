import 'package:careful_icarus/game/controllers/enemy.dart';
import 'package:careful_icarus/game/managers/game_manager.dart';
import 'package:careful_icarus/game/managers/sound_manager.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careful_icarus/game/icarus.dart';
import 'package:careful_icarus/game/controllers/player.dart';

void main() {
  test('Player should jump when jump() is called', () {
    SoundManager.mute(); //tests crash if sounds try to be played

    // Create a new Player instance
    final player = Player(position: Vector2.zero());
    player.disableControls = false;

    // Call the jump() method
    player.jump();

    // Verify that the player's velocity.y is less than 0, indicating a jump
    expect(player.velocity.y, lessThan(0.0));
  });

  test('Player should fall after hitting enemy', () {
    // Create a new Player instance
    final player = Player(position: Vector2.zero());
    final enemy = Enemy();
    player.onCollisionStart({player.position}, enemy);

    // Verify that the player's has lost
    expect(player.startFall, true);
  });
}
