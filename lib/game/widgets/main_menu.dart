import 'package:careful_icarus/game/managers/sound_manager.dart';
import 'package:careful_icarus/game/widgets/shop_page.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';
import '../managers/game_manager.dart';
import 'game_over.dart';

class MainMenu extends StatefulWidget {
  const MainMenu(this.game, {super.key});

  final Game game;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  gameover() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GameOver(score: GameManager.fishGatheredRun)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () => SoundManager.mute(),
        child: Icon(Icons.volume_off),
      ),
      body: Center(
        child: Text(
          'ICARUS',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      bottomSheet: Container(
          child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Image.asset('assets/images/VictoryDance.gif'),
      )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 16,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => GameWidget(
                                game: Icarus(
                                    viewportResolution: Vector2(
                                        MediaQuery.of(context).size.width,
                                        MediaQuery.of(context).size.height),
                                    notifyParent: gameover))),
                      );
                    },
                    child: Text('PLAY'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.red,
                      elevation: 5,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 16,
                  height: 100,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShopPage(widget.game)));
                    },
                    label: Text('Shop'),
                    icon: Icon(Icons.shopping_cart),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shadowColor: Colors.red,
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
