import 'package:careful_icarus/game/player_object.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'player_controller.dart';

// game main function
class Icarus extends FlameGame {
  Icarus({required Vector2 viewportResolution}) {
    // ignore: prefer_initializing_formals
    Icarus.viewportResolution = viewportResolution;
  }

  static late Vector2 viewportResolution; 

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
    // the player object or character
    var playerChar = PlayerObject(size: Vector2(200, 200));
    // the player controller handling all inpus from the player
    var playerInput = PlayerControls(playerChar, size: viewportResolution);

    cameraComponent.add(playerInput); // add the player input field to always be laid under the camera

    world.addAll([playerChar]);
    cameraComponent.follow(playerChar);

  }
}
