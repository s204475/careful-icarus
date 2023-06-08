import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';

class PlayerCharacter<T extends Forge2DGame> extends SpriteComponent with HasGameReference<T> {
  PlayerCharacter({super.position, super.priority}) : super(
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('PixelPenguin1.png');
  }
}