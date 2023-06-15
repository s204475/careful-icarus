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
  var _velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("Sealion_cloud1.png");

    await add(CircleHitbox());
    debugMode = GameManager.debugging;

    Icarus.world.add(warn);
    warn.position =
        Vector2(this.position.x, Icarus.cameraComponent.visibleWorldRect.top);
  }

  @override
  Future<void> update(double dt) async {
    _move(dt);
    super.update(dt);
    await checkIfBelow();
    double distance =
        Icarus.cameraComponent.visibleWorldRect.top + warn.height / 2;
    if (warn.position.y <= this.position.y) {
      warn.destroy();
    } else {
      warn.position = Vector2(this.position.x, distance);
    }
  }

  @override
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
