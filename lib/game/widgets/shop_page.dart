import 'package:careful_icarus/main.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';
import 'shopping_button.dart';

class ShopPage extends StatefulWidget {
  const ShopPage(this.game, {super.key});

  final Game game;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Shop Page'),
          Text('[ A string containing how many fish you have :D ]'),
          ListView.builder(
            itemCount: 8,
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ShoppingButton('Upgrade $index');
            },
          ),
        ],
      ),
      bottomSheet: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GameWidget(game: Icarus(viewportResolution: Vector2(0, 0)))
              ),
            );
          },
          child: const Text('START'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
