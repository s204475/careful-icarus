import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';

import 'game/icarus.dart';
import 'game/util/util.dart';
import 'game/widgets/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
//Main only serves to startup the game, everything else is handled by Icarus

/*    If an errors appears saying something like "start ms-settings:developers"
*     type win+R and type "ms-settings:developers" and enable developer mode
*/

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icarus',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.audiowideTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Icarus'),
    );
  }
}

// til bagrunds music, skal bare køres i starten af build segmentet.
void startBgmMusic() {
    FlameAudio.bgm.initialize();
    //filen skal bare være ___.mp3, og den skal ligge i en mappe i assets der heder audio
    FlameAudio.bgm.play('');
  }


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    var safeHeight = height - padding.top - padding.bottom;

    return GameWidget(game: Icarus(viewportResolution: Vector2(width, height)));
  }
}
