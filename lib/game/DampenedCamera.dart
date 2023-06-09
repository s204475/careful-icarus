import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class DampenedCamera extends CameraComponent with HasGameRef {
  DampenedCamera({required super.world});
  
  static PositionComponent? trail;
  static PositionComponent? target;

  static double maxDistance = double.infinity;
  static double minDistance = double.infinity;
  static double speed = double.infinity;

  Future<void> followDampened(PositionComponent target, {
    double maxSpeed = double.infinity,
    bool horizontalOnly = false,
    bool verticalOnly = false,
    bool snap = false,

    double maxDistance = double.infinity,
    double minDistance = double.infinity,
    double speed = double.infinity,
  }) async {
    DampenedCamera.maxDistance = maxDistance;
    DampenedCamera.minDistance = minDistance;
    DampenedCamera.speed = speed;

    if (trail != null) {
      remove(trail!);
    }

    trail = PositionComponent(position: target.position);
    trail?.add(SpriteComponent(sprite: await gameRef.loadSprite('PixelPenguin1.png')));

    DampenedCamera.target = target;
    follow(trail!, maxSpeed: maxSpeed, horizontalOnly: horizontalOnly, verticalOnly: verticalOnly, snap: snap);
  }

  @override
  void update(double dt) {
    if (trail == null || target == null) {
      return;
    }

     var diff = target!.position - trail!.position; // vector from trail to target

    if (trail!.position.distanceTo(target!.position) >= minDistance) { // only move camera if under minDistance
      //var dir = target!.position - trail!.position; // vector from trail to target

      if (diff.length > maxDistance) { // keep camera at the max distance  allowed
        //diff.length -= maxDistance; // TODO

        //trail!.position.setFrom(diff.scaled((diff.length -= maxDistance) *dt));


      } else { // move the camera gradually to the target dependened on speed
        //trail!.position.setFrom(diff.scaled(speed *dt));

        trail!.position += diff * speed * dt;
      }
    }
    var pos = trail!.position;
    print("Camera - trail pos: $pos, dir: $diff)");
    
    super.update(dt); // to run the update on the normal camera functions
  }
}