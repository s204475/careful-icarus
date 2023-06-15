import 'package:flutter/material.dart';

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
        child: Text('Game Over! You scored ${widget.score} points!'),
      ),
    );
  }
}
