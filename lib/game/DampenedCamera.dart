import 'package:careful_icarus/game/icarus.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// The camera component that follows the player. It gradually follows the player mimicking a dampened effect
class DampenedCamera extends CameraComponent with HasGameRef {
  DampenedCamera({required super.world});

  static PositionComponent? trail;
  static PositionComponent? target;

  static double maxDistance = double.infinity;
  static double minDistance = 0;
  static double speed = 1; // the actual speed

  static double maxSpeed = double.infinity;
  static bool horizontalOnly = false;
  static bool verticalOnly = false;
  static bool snap = false;
  static bool lockHeight = false;

  @override
  Future<void> onLoad() async {
  super.onLoad();
  
  priority = 99;
}

  Future<void> followDampened(
    PositionComponent target, {
    double maxSpeed = double.infinity,
    bool horizontalOnly = false,
    bool verticalOnly = false,
    bool snap = false,
    bool lockHeight = false,
    double maxDistance = double.infinity,
    double minDistance = 0,
  }) async {
    assert(maxDistance >= minDistance);

    DampenedCamera.maxSpeed = maxSpeed;
    DampenedCamera.horizontalOnly = horizontalOnly;
    DampenedCamera.verticalOnly = verticalOnly;
    DampenedCamera.snap = snap;

    DampenedCamera.lockHeight = lockHeight;
    DampenedCamera.maxDistance = maxDistance;
    DampenedCamera.minDistance = minDistance;
    DampenedCamera.target = target;

    if (trail != null) {
      remove(trail!);
    }

    trail = PositionComponent(position: target.position);
    trail?.add(
        SpriteComponent(sprite: await gameRef.loadSprite('PixelPenguin1.png')));

    follow(trail!,
        maxSpeed: maxSpeed,
        horizontalOnly: horizontalOnly,
        verticalOnly: verticalOnly,
        snap: snap);
  }

  @override
  void update(double dt) {
    
    Vector2 followPos = trail!.position;
    Vector2 playerPos = target!.position;

    Vector2 deltaPos = playerPos - followPos;

    if (horizontalOnly || lockHeight && deltaPos.y > 0) {
      deltaPos.y = 0;
    } else {
      if (deltaPos.y > 0 ? false : -deltaPos.y > minDistance) {
        deltaPos.y += minDistance;
      } else {
        deltaPos.y = 0;
      }
    }
    if (verticalOnly) {
      deltaPos.x = 0;
    } else {
      if (deltaPos.x > 0 ? false : -deltaPos.x > minDistance) {
        deltaPos.x += minDistance;
      } else {
        deltaPos.x = 0;
      }
    }

    trail!.position += deltaPos;
  }
}