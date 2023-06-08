import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'player_controller.dart';

// game main function
class Icarus extends FlameGame {
  Icarus({required Vector2 viewportResolution}) {
    Icarus.viewportResolution = viewportResolution;
  }

  static late final Vector2 viewportResolution; 

  @override
  Color backgroundColor() => Colors.lightBlue;

  late final CameraComponent cameraComponent;

  @override
  Future<void> onLoad() async {
    final world = World();
    cameraComponent = CameraComponent(
      world: world,
    );
    addAll([world, cameraComponent]);


    debugPrint("loading Game");
    var player = PlayerControls();

    world.addAll([player]);
    cameraComponent.follow(player);
  }
}
