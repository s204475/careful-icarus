import 'package:careful_icarus/game/widgets/shop_page.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

import '../icarus.dart';

class GameOver extends StatefulWidget {
  const GameOver({Key? key, required this.score}) : super(key: key);

  final int score;

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(children: [
        Text('Game Over! You scored ${widget.score} points!'),
        ElevatedButton(
          child: const Text('Main Menu'),
          onPressed: () {
            //Navigator.of(context).push(
            //  MaterialPageRoute(builder: (context) => ShopPage(null)),
            //);
            Restart.restartApp(); //does not work on IOS, but works on Android
          },
        )
      ])),
    );
  }

  gameover() {}
}
