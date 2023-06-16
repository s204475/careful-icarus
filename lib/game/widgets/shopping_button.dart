import 'package:careful_icarus/game/managers/upgrade_manager.dart';
import 'package:careful_icarus/game/widgets/shop_page.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';

class ShoppingButton extends Container {
  final Function() notifyParent;
  ShoppingButton(this.upgradeName, {super.key, required this.notifyParent});

  final String upgradeName;
  Map upgrades = UpgradeManager.upgrades;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
                '[${upgrades[upgradeName]["level"]}] $upgradeName cost: ${upgrades[upgradeName]["cost"]}')),
        ElevatedButton(
          onPressed: () {
            UpgradeManager.buyUpgrades(upgradeName);
            notifyParent();
          },
          child: Icon(Icons.add),
        ),
        ElevatedButton(
          onPressed: () {
            print('minus one of $upgradeName'); //TODO implement this
          },
          child: Icon(Icons.remove),
        ),
      ],
    );
  }
}
