import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class DampenedCamera extends CameraComponent with HasGameRef {
  DampenedCamera({required super.world});
  
  static PositionComponent? trail;
  static PositionComponent? target;

  static double maxDistance = double.infinity;
  static double minDistance = 0;
  static double speed = 1; // the actual speed
  static double acceleration = 1; // the accelration to increase the speed based on distance
  static bool lockHeight = false;

  static double maxSpeed = double.infinity;
  static bool horizontalOnly = false;
  static bool verticalOnly = false;
  static bool snap = false;

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
    trail?.add(SpriteComponent(sprite: await gameRef.loadSprite('PixelPenguin1.png')));

    follow(target!, maxSpeed: maxSpeed, horizontalOnly: horizontalOnly, verticalOnly: verticalOnly, snap: snap);
  }

  static void fixedUpdated(double dt) { // an update method that is always called after the players update
    if (trail == null || target == null) {
      return;
    }

    Vector2 pos = trail!.position;

    if (pos.distanceTo(target!.position) > minDistance) { // only move camera if under minDistance
      var dir = target!.position - pos; // vector from trail to target

      if (dir.length >= maxDistance) { // keep camera at the max distance  allowed
        dir.length -= maxDistance;

        pos += dir;

      } else { // move the camera gradually to the target dependened on speed
        pos += dir * speed * dt;
      }
    }

    if (horizontalOnly) {
      pos.y = 0;
    }
    if (verticalOnly) {
      pos.x = 0;
    }

    trail!.position = pos;
  }

  
}