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
            child: Text( //string interpolation is used here to display the level and cost of the upgrade
                '[${upgrades[upgradeName]["level"]}] $upgradeName cost: ${upgrades[upgradeName]["cost"]}')),
        ElevatedButton(
          onPressed: () {
            UpgradeManager.buyUpgrades(upgradeName);
            notifyParent();
          },
          child: const Icon(Icons.add),
        ),
        ElevatedButton(
          onPressed: () {}, //further development should allow player to "undo" purchases
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
