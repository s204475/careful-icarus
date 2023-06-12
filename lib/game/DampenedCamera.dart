import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class DampenedCamera extends CameraComponent with HasGameRef {
  DampenedCamera({required super.world});
  
  static PositionComponent? trail;
  static PositionComponent? target;

  static double maxDistance = double.infinity;
  static double minDistance = double.infinity;
  static double speed = double.infinity; // the actual speed
  static double acceleration = 1; // the accelration to increase the speed based on distance

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    priority = 999; // to make sure the camera is updated last
  }

  Future<void> followDampened(PositionComponent target, {
    double maxSpeed = double.infinity,
    bool horizontalOnly = false,
    bool verticalOnly = false,
    bool snap = false,

    double maxDistance = double.infinity,
    double minDistance = double.infinity,
    double acceleration = 1,
  }) async {
    DampenedCamera.maxDistance = maxDistance;
    DampenedCamera.minDistance = minDistance;
    DampenedCamera.acceleration = acceleration;

    if (trail != null) {
      remove(trail!);
    }

    trail = PositionComponent(position: target.position);
    trail?.add(SpriteComponent(sprite: await gameRef.loadSprite('PixelPenguin1.png')));

    DampenedCamera.target = target;
    follow(target!, maxSpeed: maxSpeed, horizontalOnly: horizontalOnly, verticalOnly: verticalOnly, snap: snap);
  }

  @override
  void update(double dt) {
    if (trail == null || target == null) {
      return;
    }

    if (trail!.position.distanceTo(target!.position) >= minDistance) { // only move camera if under minDistance
      var dir = target!.position - trail!.position; // vector from trail to target

      if (dir.length > maxDistance) { // keep camera at the max distance  allowed
        dir.length -= maxDistance;

        trail!.position += dir;

      } else { // move the camera gradually to the target dependened on speed
        //trail!.position += dir * speed * dt;

      }
    }
    var pos = trail!.position;
    print("Camera - trail pos: $pos)");
    
    super.update(dt); // to run the update on the normal camera functions
  }
}