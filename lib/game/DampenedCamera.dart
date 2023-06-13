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
  static double acceleration =
      1; // the accelration to increase the speed based on distance

  static double maxSpeed = double.infinity;
  static bool horizontalOnly = false;
  static bool verticalOnly = false;
  static bool snap = false;
  static bool lockHeight = false;


  static Vector2 offset = Vector2(0,100);

  Future<void> followDampened(
    PositionComponent target, {
    double maxSpeed = double.infinity,
    bool horizontalOnly = false,
    bool verticalOnly = false,
    bool snap = false,
    bool lockHeight = false,
    double maxDistance = double.infinity,
    double minDistance = 0,
    double acceleration = 1,
  }) async {
    assert(maxDistance >= minDistance);

    DampenedCamera.maxSpeed = maxSpeed;
    DampenedCamera.horizontalOnly = horizontalOnly;
    DampenedCamera.verticalOnly = verticalOnly;
    DampenedCamera.snap = snap;

    DampenedCamera.lockHeight = lockHeight;
    DampenedCamera.maxDistance = maxDistance;
    DampenedCamera.minDistance = minDistance;
    DampenedCamera.acceleration = acceleration;
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

  static void fixedUpdated(double dt, Vector2 velocity) {
    // an update method that is always called after the players update
    if (trail == null || target == null) {
      return;
    }

    minDistance = 100;

    Vector2 followPos = trail!.position;
    Vector2 playerPos = target!.position;

    Vector2 deltaPos = playerPos - followPos;
    Vector2 velOffset = velocity;

    /*
    if (pos.distanceTo(target!.position) > minDistance) { // only move camera if under minDistance
      var dir = target!.position - pos; // vector from trail to target

      if (dir.length >= maxDistance) {
        // keep camera at the max distance  allowed
        dir.length -= maxDistance;

        followPos += dir;

      } else { // move the camera gradually to the target dependened on speed
        followPos += dir * speed * dt;
      }
    }
    */

    //debugPrint("before: $deltaPos");

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

    //debugPrint("after: $deltaPos");

    trail!.position += deltaPos;
  }
}
