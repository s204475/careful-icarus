import 'package:careful_icarus/game/controllers/warning.dart';
import 'package:careful_icarus/game/icarus.dart';
import 'package:careful_icarus/game/managers/level_manager.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import '../managers/game_manager.dart';
import '../util/util.dart';
import 'platform.dart';

class Enemy extends Platform {
  var warn = Warning();
  // ignore: prefer_final_fields
  var _velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("Sealion_cloud1.png");

    await add(CircleHitbox());
    debugMode = GameManager.debugging;

    Icarus.world.add(warn);
    warn.position = Vector2(position.x, LevelManager.player.position.y - 200);
  }

  @override
  Future<void> update(double dt) async {
    _move(dt);
    super.update(dt);
    await checkIfBelow();
    double distance = LevelManager.player.position.y -
        3 * Icarus.viewportResolution.y / 4 +
        75;
    if (warn.position.y <= position.y) {
      warn.destroy();
    } else {
      warn.position = Vector2(position.x, distance);
    }
  }

  void _move(double dt) {
    if (!isMoving) return;

    if (position.x <= 0) {
      direction = 1;
    } else if (position.x >= gameRef.size.x) {
      direction = -1;
    }
    _velocity.x = direction * speed;
    position += _velocity * dt;
  }
}
