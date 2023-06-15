import 'package:careful_icarus/game/widgets/shop_page.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';

class MainMenu extends StatefulWidget {
  const MainMenu(this.game, {super.key});

  final Game game;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('ICARUS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 248, 169, 13),
                )),
            Expanded(
              child: SizedBox(
                  height: 120,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => GameWidget(
                                  game: Icarus(
                                      viewportResolution: Vector2(
                                          MediaQuery.of(context).size.width,
                                          MediaQuery.of(context)
                                              .size
                                              .height)))),
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
                  )),
            ),
            ElevatedButton(
              child: const Text('shop'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          ShopPage(Icarus(viewportResolution: Vector2(0, 0)))),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
