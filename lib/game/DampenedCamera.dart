import 'package:careful_icarus/game/icarus.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// The camera component that follows the player. It gradually follows the player mimicking a dampened effect
class DampenedCamera extends CameraComponent with HasGameRef {
  DampenedCamera({required super.world});

  static PositionComponent? trail; // the object used to follow the target, the camera is always fixed on this object
  static PositionComponent? target; // a refernce to the target for the trail to follow

  static double maxDistance = double.infinity; // used to set the max distance the camera can travel, unused TODO
  static double minDistance = 0; // the minimum distance the target can move before the trail has to follow

  static bool horizontalOnly = false; // sets if the camera should only move on the x axis
  static bool verticalOnly = false; // sets if the camera should only move on the y axis
  static bool lockHeight = false; // sets if the camera should be able to move down on the y axis

  static Vector2 _offset = Vector2.zero(); // offset used to move the camera a fixed relative distance from the target

  @override
  Future<void> onLoad() async {
  super.onLoad();
  
  priority = 99;

  viewfinder.zoom = 0.5; // the size of a pixel 1:1, 1:4
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
    DampenedCamera.horizontalOnly = horizontalOnly;
    DampenedCamera.verticalOnly = verticalOnly;

    DampenedCamera.lockHeight = lockHeight;
    DampenedCamera.maxDistance = maxDistance;
    DampenedCamera.minDistance = minDistance;
    DampenedCamera.target = target;

    if (trail != null) { // make sure the camera only follows a single target, while removing now unused objects
      remove(trail!);
    }

    DampenedCamera._offset.y = -viewfinder.visibleWorldRect.size.height / 4; // 

    trail = PositionComponent(position: target.position + _offset);
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
    
    Vector2 followPos = trail!.position - _offset;
    Vector2 playerPos = target!.position;

    Vector2 deltaPos = playerPos - followPos;
    
    if (horizontalOnly || lockHeight && deltaPos.y > 0) {
      deltaPos.y = 0;
    } else {
      if (deltaPos.y > 0 ? false : -deltaPos.y > minDistance) {
        deltaPos.y += minDistance;
        if (-deltaPos.y < maxDistance) {
          deltaPos.y += -deltaPos.y*dt*2;
        }
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