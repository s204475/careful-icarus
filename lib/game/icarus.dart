import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'DampenedCamera.dart';
import 'package:flame/events.dart';
import 'package:flutter/rendering.dart';
import 'controllers/player.dart';
import 'managers/level_manager.dart';
import 'dart:math';

enum Character { penguin }

/// The main game class. Initialises the game and creates the @level_manager.
class Icarus extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  Icarus({required Vector2 viewportResolution}) {
    // ignore: prefer_initializing_formals
    Icarus.viewportResolution = viewportResolution;
  }

  static late Vector2 viewportResolution;
  static var world;
  static late DampenedCamera cameraComponent;
  late var levelManager;
  int lastPlatformYpos = 0;

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    world = World();
    cameraComponent = DampenedCamera(
      world: world,
    );

    addAll([world, cameraComponent]);
    debugPrint("loading level");
    levelManager = LevelManager(this, cameraComponent);
    await levelManager.StartLevel();
    lastPlatformYpos = levelManager.lastYpos;

    print("viewport res: $viewportResolution");
    add(TapTarget());

    debugPrint("loading complete");
  }

  @override
  Future<void> update(double dt) async {
    // add platforms if needed, 20 at a time
    if (LevelManager.player.position.y < (-lastPlatformYpos + 400 * 5)) {
      lastPlatformYpos =
          await levelManager.addPlatforms(lastPlatformYpos, 400, 20);
    }
    super.update(dt);
  }
}

/// A simple component that responds when the user taps the screen. Currently draws a circle
class TapTarget extends PositionComponent with TapCallbacks {
  TapTarget();

  final _paint = Paint()..color = const Color(0x448BA8FF);

  /// We will store all current circles into this map, keyed by the `pointerId`
  /// of the event that created the circle.
  final Map<int, ExpandingCircle> _circles = {};

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (this.size.x < 100 || this.size.y < 100) {
      this.size = size * 0.9;
    }
    position = size / 2;
  }

  //start moving depending on the side of touch
  @override
  void onTapDown(TapDownEvent event) {
    debugPrint("TapdownEvent");
    final circle = ExpandingCircle(event.localPosition);
    _circles[event.pointerId] = circle;
    add(circle);
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    _circles[event.pointerId]!.accent();
    //Player.sprite.position.x-=50;
  }

  //stop moving
  @override
  void onTapUp(TapUpEvent event) {
    _circles.remove(event.pointerId)!.release();
  }
}

class ExpandingCircle extends Component {
  ExpandingCircle(this._center)
      : _baseColor =
            HSLColor.fromAHSL(1, random.nextDouble() * 360, 1, 0.8).toColor();

  final Color _baseColor;
  final Vector2 _center;
  double _outerRadius = 0;
  double _innerRadius = 0;
  bool _released = false;
  bool _cancelled = false;
  late final _paint = Paint()
    ..style = PaintingStyle.stroke
    ..color = _baseColor;

  /// "Accent" is thin white circle generated by `onLongTapDown`. We use
  /// negative radius to indicate that the circle should not be drawn yet.
  double _accentRadius = -1e10;
  late final _accentPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0
    ..color = const Color(0xFFFFFFFF);

  /// At this radius the circle will disappear.
  static const maxRadius = 175;
  static final random = Random();

  double get radius => (_innerRadius + _outerRadius) / 2;

  void release() => _released = true;
  void cancel() => _cancelled = true;
  void accent() => _accentRadius = 0;

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(_center.toOffset(), radius, _paint);
    if (_accentRadius >= 0) {
      canvas.drawCircle(_center.toOffset(), _accentRadius, _accentPaint);
    }
  }

  @override
  void update(double dt) {
    if (_cancelled) {
      _innerRadius += dt * 100; // implosion
    } else {
      _outerRadius += dt * 20;
      _innerRadius += dt * (_released ? 20 : 6);
      _accentRadius += dt * 20;
    }
    if (radius >= maxRadius || _innerRadius > _outerRadius) {
      removeFromParent();
    } else {
      final opacity = 1 - radius / maxRadius;
      _paint.color = _baseColor.withOpacity(opacity);
      _paint.strokeWidth = _outerRadius - _innerRadius;
    }
  }
}
