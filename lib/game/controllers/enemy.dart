import 'package:flame/collisions.dart';
import 'package:flutter/widgets.dart';

import '../managers/game_manager.dart';
import '../util/util.dart';
import 'platform.dart';

class Enemy extends Platform {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("Cloud3.png");

    await add(CircleHitbox());
    debugMode = GameManager.debugging;
  }
}
