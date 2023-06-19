import 'package:flutter/cupertino.dart';

import '../util/local_storage.dart';

class UpgradeManager {
  static Map upgrades = {
    "Sealion Protection": {
      "cost": 10,
      "description": "Protects penguins from predators",
      "level": 0,
      "multiplier": 1.0
    },
    "Idle Fisher": {
      "cost": 10,
      "description": "Fish while you're away",
      "level": 0,
      "multiplier": 1.0
    },
    "Jump Strength": {
      "cost": 10,
      "description": "Jump higher",
      "level": 0,
      "multiplier": 1.0
    },
    "Launch Strength": {
      "cost": 10,
      "description": "Get launched off the iceberg",
      "level": 0,
      "multiplier": 1.0
    },
    "Fish Multiplier": {
      "cost": 10,
      "description": "Catch more fish",
      "level": 0,
      "multiplier": 1.0
    },
    "Wax Integrity": {
      "cost": 10,
      "description": "Protects wax from melting",
      "level": 0,
      "multiplier": 1.0
    }
  };

  static Future<Map> readUpgrades() async {
    var upgradeBuffer = await readMap("stats");
    if (upgradeBuffer.isNotEmpty) {
      upgrades = await readMap("stats");
    }
    return upgrades;
  }

  static Future<void> writeUpgrades() async {
    await writeMap("stats", upgrades);
  }

  static num fish = 0;

  static Future<void> readFish() async {
    fish = await readInt("fishGatheredTotal");
  }

  static void buyUpgrades(String name) {
    if (!upgrades.containsKey(name)) {
      return;
    }
    if (fish >= upgrades[name]["cost"]) {
      fish -= upgrades[name]["cost"];
      upgrades[name]["level"]++;
      //debugPrint("bought $name for ${upgrades[name]["cost"]} fish, level is now ${upgrades[name]["level"]}");
      upgrades[name]["cost"] *= 2;
      upgrades[name]["multiplier"] *= 1.5;
      writeInt("fishGatheredTotal", fish.toInt());
      writeUpgrades();
    }
    //print(UpgradeManager.upgrades);
  }

  static void resetUpgrades() {
    upgrades.clear();
    writeUpgrades();
  }
}
