// ignore_for_file: invalid_use_of_internal_member

import 'package:careful_icarus/game/icarus.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'managers/level_manager.dart';

/// The camera component that follows the player. It gradually follows the player mimicking a dampened effect
class DampenedCamera extends CameraComponent with HasGameRef {
  DampenedCamera({required super.world});

  /// The object used to follow the target, the camera is always fixed on this object
  static PositionComponent? trail;

  /// A refernce to the target for the trail to follow
  static PositionComponent? target;

  /// Used to set the max distance the camera can travel
  static double maxDistance = double.infinity;

  /// The minimum distance the target can move before the trail has to follow
  static double minDistance = 0;

  /// Sets if the camera should only move on the x axis
  static bool horizontalOnly = false;

  /// Sets if the camera should only move on the y axis
  static bool verticalOnly = false;

  /// Sets if the camera should be able to move down on the y axis
  static bool lockHeight = false;

  /// offset used to move the camera a fixed relative distance from the target
  static Vector2 _offset = Vector2.zero();

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

    if (trail != null) {
      // make sure the camera only follows a single target, while removing now unused objects
      remove(trail!);
    }

    DampenedCamera._offset.y = -viewfinder.visibleWorldRect.size.height / 4; //

    trail = PositionComponent(position: target.position + _offset);

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
        /*
        if (-deltaPos.y < maxDistance) {
          deltaPos.y += -deltaPos.y*dt*2;
          //deltaPos.y = deltaPos.y*(1/LevelManager.player.velocity.y);
        } else {
          deltaPos.y += maxDistance - minDistance;
        }
        */
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
