import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static late var ap;
  static bool _theme_playing = false;

  static void playSound(String path, double volume) {
    FlameAudio.play(path, volume: volume);
  }

  static void playMusic() {
    if (_theme_playing == false) {
      ap = FlameAudio.bgm.play("FlyingPenguins_Theme.mp3");
      _theme_playing = true;
    }
  }

  static void stopMusic() {
    if (_theme_playing == true) {
      FlameAudio.bgm.stop();
      _theme_playing = false;
    }
  }
}
