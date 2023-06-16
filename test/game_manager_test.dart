import 'package:careful_icarus/game/managers/game_manager.dart';
import 'package:careful_icarus/game/managers/level_manager.dart';
import 'package:careful_icarus/game/util/local_storage.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Fish idled should be 0 when no time have passed', () {
    GameManager.levelStartTime = DateTime.now();
    int fishIdled = GameManager.getFishIdled();

    expect(fishIdled, equals(0));
  });

  test('Fish idled should increase when upgrading the powerup', () {
    final aMinuteAgo = (DateTime.now())
        .subtract(const Duration(seconds: Duration.secondsPerMinute));
    GameManager.levelStartTime = aMinuteAgo;
    int previousUpgradeFish = 0;
    GameManager.idleFisher = 1;

    for (int i = 0; i < 5; i++) {
      //5 upgrades. Each upgrade should increase the fish gotten.
      int fishIdled = GameManager.getFishIdled();
      expect(previousUpgradeFish, lessThan(fishIdled));
      previousUpgradeFish = fishIdled;
      GameManager.idleFisher *= 1.5; //Simulate upgrading powerup
    }
  });
}
