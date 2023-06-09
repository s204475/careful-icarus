import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';

class ShopPage extends StatefulWidget {
    const ShopPage (this.game, {super.key});

    final Game game;
    
    @override
    State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
    @override
    Widget build(BuildContext context) {
          return Column(
            children: [
                  Text('Shop Page'),
                  Text('[ A string containing how many fish you have :D ]'),
                  ListView(
                    padding: const EdgeInsets.all(80),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[ //put widget type in here once we have shop buttons
                      ElevatedButton(
                        onPressed: () {
                          print('Hello there!');
                          },
                          child: const Text('Say Hello'),
                        ),
                        ElevatedButton(
                        onPressed: () {
                          print('Hello again!');
                          },
                          child: const Text('Say Hello 2'),
                        ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: (){
                            //set state to game
                          },
                          child: const Text('START'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                      
                    ),
                  )
            ],
        );
    }
}