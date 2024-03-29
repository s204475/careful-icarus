import 'package:careful_icarus/game/managers/game_manager.dart';
import 'package:careful_icarus/game/managers/sound_manager.dart';
import 'package:careful_icarus/game/managers/upgrade_manager.dart';
import 'package:careful_icarus/game/util/util.dart';
import 'package:careful_icarus/main.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../icarus.dart';
import 'game_over.dart';
import 'main_menu.dart';
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

  gameover() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GameOver(score: GameManager.fishGatheredRun)));
    });
  }

  onSelected(int item) {
    switch (item) {
      case 0:
        setState(() {
          SoundManager.mute();
        });
        break;
      case 1:
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => MainMenu(Icarus(
                    viewportResolution: Vector2(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                    notifyParent: gameover))),
          );
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text('Shop Page'),
          Text('[ You have $fish fish.]'),
          ListView.builder( //constructs a list of buttons for each upgrade
            itemCount: upgrades.length,
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ShoppingButton(upgrades.keys.toList()[index],
                  notifyParent: refresh); //calls the refresh method
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: PopupMenuButton<int>( //places a settings button in the top right
        icon: const Icon(Icons.settings),
        onSelected: (item) {
          onSelected(item);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 0,
            child: Icon(Icons.volume_off),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text("Quit to Menu"),
          ),
        ],
      ),
      bottomSheet: SizedBox(  //places the start button at the bottom of the screen
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => GameWidget(
                        game: Icarus( //gets the screen size, then passes it to the game via gameover()
                            viewportResolution: Vector2(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
                            notifyParent: gameover))),
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('START'),
        ),
      ),
    );
  }
}
