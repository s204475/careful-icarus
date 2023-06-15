
import 'package:careful_icarus/game/DampenedCamera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../icarus.dart';

class HeightCounter extends HudMarginComponent {
  HeightCounter({super.anchor, super.margin, super.position});

  late final TextComponent _counterComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final textStyle = GoogleFonts.vt323(
      fontSize: 35,
      color: Colors.purple,
    );
    final defaultRenderer = TextPaint(style: textStyle);

    _counterComponent = TextComponent(
      text: "test",
      position: Vector2(0, 0),
      anchor: Anchor.center,
      textRenderer: defaultRenderer,
    );
    add(_counterComponent);

    _backgroundPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
  }

  final _backgroundRect = RRect.fromRectAndRadius(
    Rect.fromCircle(center: Offset.zero, radius: 50),
    const Radius.circular(10),
  );
  late final Paint _backgroundPaint;

  @override
  void render(Canvas canvas) {
    //canvas.drawRRect(_backgroundRect, _backgroundPaint);
  }

  @override
  void update(double dt) {
    //_timePassedComponent.text = gameRef.timePassed;
    _counterComponent.text = DampenedCamera.target?.height.toString() ?? "nulled";
  }
}

class CountDown extends TimerComponent {
  CountDown({required super.period});
  
}