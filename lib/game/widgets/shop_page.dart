import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';
import 'shopping_button.dart';

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
                    children: <ShoppingButton>[
                      ShoppingButton('Upgrade 1'),
                      ShoppingButton('Upgrade 2'),
                      ShoppingButton('Upgrade 3'),
                      ShoppingButton('Upgrade 4'),
                      ShoppingButton('Upgrade 5'),
                    ],
                  ),
                  
                    Expanded(
                      
                      child: Align(
                        alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            child: ElevatedButton(
                              onPressed: (){
                                //set state to game
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
                          
                        
                      ),
                    ),
            ],
        );
    }
}