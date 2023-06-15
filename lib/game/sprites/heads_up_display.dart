
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeightCounter extends HudMarginComponent {
  HeightCounter({super.anchor, required super.margin, super.position});

  TextComponent text = TextComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final textStyle = GoogleFonts.vt323(
      fontSize: 35,
      color: Colors.purple,
    );
    final defaultRenderer = TextPaint(style: textStyle);

    add(
      TextComponent(
        text: "test",
        position: Vector2(0, 0),
        anchor: Anchor.center,
        textRenderer: defaultRenderer,
      ),
    );

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
    canvas.drawRRect(_backgroundRect, _backgroundPaint);
  }
}

class CountDown extends TimerComponent {
  CountDown({required super.period});
  
}