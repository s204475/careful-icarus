
import 'package:careful_icarus/game/DampenedCamera.dart';
import 'package:careful_icarus/game/managers/game_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../icarus.dart';
import '../managers/level_manager.dart';

class HeightCounter extends HudMarginComponent with HasGameRef<Icarus> {
  HeightCounter({super.anchor, super.margin, super.position});

  late final TextComponent _scoreComponent;
  late final TextComponent _timerComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final textStyle = GoogleFonts.vt323(
      fontSize: 35,
      color: Colors.purple,
    );
    final defaultRenderer = TextPaint(style: textStyle);

    _scoreComponent = TextComponent(
      position: Vector2(0, 40),
      anchor: Anchor.center,
      textRenderer: defaultRenderer,
    );
    add(_scoreComponent);
    
    _timerComponent = TextComponent(
      position: Vector2(0, 70),
      anchor: Anchor.center,
      textRenderer: defaultRenderer,
    );
    //add(_timerComponent);

    //_startingOffset = -LevelManager.player.position.y;
    _startingOffset = -(DampenedCamera.trail?.position.y ?? 0);
    //_startingOffset = _startingOffset > 0 ? _startingOffset : -_startingOffset;
  }

  double _timePassed = 0;

  String _addZero(int number) {
    if (number < 10) {
      if (number < 0) {
        var tempNum = -number;
        return '-0$tempNum';
      }
      return '0$number';
    }
    return number.toString();
  }

  String timePassed(time) {
    final minutes = _addZero((time / 60).floor());
    final seconds = _addZero((time % 60).floor());
    final miliseconds = _addZero(((time % 1) * 100).floor());
    return [minutes, seconds, miliseconds].join(':');
  }

  @override
  void update(double dt) {
    //_timerComponent.text = timePassed(300 - _timePassed);
    //_scoreComponent.text = DampenedCamera.target?.height.toString() ?? "nulled";
    //_scoreComponent.text = getHeight();
    _scoreComponent.text = GameManager.totalfish.toString();

    //_timePassed += dt;
  }

  late double _startingOffset;

  String getHeight() {
    //var curPos = LevelManager.player.position.y + _startingOffset + 15;
    var curPos = (DampenedCamera.trail?.position.y ?? 0) + _startingOffset;
    curPos = curPos > 0 ? curPos : -curPos;


    return (curPos).toInt().toString();
  }
}