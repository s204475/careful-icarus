import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';

import 'game/icarus.dart';
import 'game/util/util.dart';
import 'game/widgets/widgets.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Level {game, mainMenu, shop}

class _HomePageState extends State<HomePage> {
  Level lvl = Level.game;

  @override
  Widget build(BuildContext context) {
    Widget scene;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    var safeHeight = height - padding.top - padding.bottom;
  
  switch (lvl) {
    case Level.game:
      scene = GameWidget(game: Icarus(viewportResolution: Vector2(width, height)));
      break;
    // case 1:
    //   scene = ShopPage();
    //   break;
    // case 2:
    //   scene = MainMenu();
    //   break;
    default:
      throw UnimplementedError('no widget for $lvl.toString()');
    }
  return LayoutBuilder(builder: (context,constraints){
    return scene;
  }
  );
  }
}
