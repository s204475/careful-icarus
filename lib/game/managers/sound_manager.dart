import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static bool _themePlaying = false;

  static void playSound(String path, double volume) {
    FlameAudio.play(path, volume: volume);
  }

  static void playMusic() {
    if (_themePlaying == false) {
      FlameAudio.bgm.play("FlyingPenguins_Theme.mp3");
      _themePlaying = true;
    }
  }

  static void stopMusic() {
    if (_themePlaying == true) {
      FlameAudio.bgm.stop();
      _themePlaying = false;
    }
  }
}
