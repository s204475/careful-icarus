import 'package:careful_icarus/game/icarus.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class DampenedCamera extends CameraComponent with HasGameRef {
  DampenedCamera({required super.world});
  
  static PositionComponent? trail;
  static PositionComponent? target;

  static double maxDistance = double.infinity;
  static double minDistance = 0;
  static double speed = 1; // the actual speed
  static double acceleration = 1; // the accelration to increase the speed based on distance

  static double maxSpeed = double.infinity;
  static bool horizontalOnly = false;
  static bool verticalOnly = false;
  static bool snap = false;
  static bool lockHeight = false;


  static Vector2 offset = Vector2(0,200);


  Future<void> followDampened(PositionComponent target, {
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
    trail?.add(SpriteComponent(sprite: await gameRef.loadSprite('Flyfish1.png')));
    Icarus.world.add(trail);

    var trail2 = PositionComponent(position: target.position + Vector2(0,40));
    trail2?.add(SpriteComponent(sprite: await gameRef.loadSprite('Flyfish2.png')));
    target.add(trail2);

    follow(trail!, maxSpeed: maxSpeed, horizontalOnly: horizontalOnly, verticalOnly: verticalOnly, snap: snap);
  }

  static void fixedUpdated(double dt) { // an update method that is always called after the players update
    if (trail == null || target == null) {
      return;
    }

    Vector2 followPos = trail!.position + offset;
    Vector2 playerPos = target!.position;

    Vector2 deltaPos = playerPos - followPos;
    /*
    if (followPos.distanceTo(target!.position) > minDistance) { // only move camera if under minDistance
      var dir = target!.position - followPos; // vector from trail to target

      if (dir.length >= maxDistance) { // keep camera at the max distance  allowed
        dir.length -= maxDistance;

        followPos += dir;

      } else { // move the camera gradually to the target dependened on speed
        followPos += dir * speed * dt;
      }
    }
    */
    if (horizontalOnly || lockHeight && deltaPos.y > 0) {
      deltaPos.y = 0;
    } else {
      var diff = deltaPos.y;
      var val = diff < 0 ? -1 : 1;
      diff = diff > 0 ? diff : -diff;
      if (diff > minDistance) {
        if (diff >= maxDistance + offset.y) {
          deltaPos.y += (maxDistance - diff) * val;
        } else {
          deltaPos.y += diff * speed * dt;
        }
      }
    }
    if (verticalOnly) {
      deltaPos.x = 0;
    } else {
      var diff = deltaPos.x;
      var val = diff < 0 ? -1 : 1;
      diff = diff > 0 ? diff : -diff;
      if ((diff > 0 ? diff : -diff) > minDistance) {
        if (diff >= maxDistance) {
          deltaPos.x += (maxDistance - diff) * val;
        } else {
          deltaPos.y += diff * speed * dt;
        }
      }
    }

    debugPrint("$deltaPos");

    trail!.position += deltaPos;
  }


}