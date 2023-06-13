import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';

class MainMenu extends StatefulWidget {
    const MainMenu (this.game, {super.key});

    final Game game;

    @override
    State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
    @override
    Widget build(BuildContext context) {
        return const Scaffold(
          body: Center(
            child: Column(
              children: [
                Text('Main Menu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ))
              ],
          
            ),
          )
        );
    }
}