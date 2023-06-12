import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';

class ShoppingButton extends Container {

  ShoppingButton(this.upgradeName, {super.key});

  final String upgradeName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('$upgradeName')),
        ElevatedButton(
          onPressed: () {
            print('plus one of $upgradeName');
          },
          child: Icon(Icons.add),
        ),
        ElevatedButton(
          onPressed: () {
            print('minus one of $upgradeName');
          },
          child: Icon(Icons.remove),
        ),
      ],
    );
  }
}