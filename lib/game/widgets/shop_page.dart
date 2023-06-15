import 'package:careful_icarus/game/managers/game_manager.dart';
import 'package:careful_icarus/game/managers/upgrade_manager.dart';
import 'package:careful_icarus/game/util/util.dart';
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
  num fish = UpgradeManager.fish;
  Map upgrades = UpgradeManager.upgrades;

  refresh() {
    setState(() {
      fish = UpgradeManager.fish;
      upgrades = UpgradeManager.upgrades;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Shop Page'),
          Text('[ You have $fish fish.]'),
          ListView.builder(
            itemCount: upgrades.length,
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ShoppingButton(upgrades.keys.toList()[index],
                  notifyParent: refresh);
            },
          ),
        ],
      ),
      bottomSheet: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => GameWidget(
                        game: Icarus(
                            viewportResolution: Vector2(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height)))),
              );
            });
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
