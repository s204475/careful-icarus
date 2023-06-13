import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';

import 'game/icarus.dart';
import 'game/util/util.dart';
import 'game/widgets/widgets.dart';
import 'game/widgets/main_menu.dart';
import 'game/widgets/shop_page.dart';

//Main only serves to startup the game, everything else is handled by Icarus

/*    If an errors appears saying something like "start ms-settings:developers"
*     type win+R and type "ms-settings:developers" and enable developer mode
*/

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget  {
  const MainApp({super.key});

void changeLevel(Level lvl) {
        _HomePageState.lvl = lvl;
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icarus',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        textTheme: GoogleFonts.robotoFlexTextTheme(ThemeData.light().textTheme),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.robotoFlexTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Icarus'),
    );
  }
}

enum Level {game, mainMenu, shop}

class HomePage extends StatefulWidget  {
  const HomePage({Key? key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

  class _HomePageState extends State<HomePage> {
  static Level lvl = Level.shop;

  @override
  Widget build(BuildContext context) {
    Widget scene;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    var safeHeight = height - padding.top - padding.bottom;

  print('switch statement $lvl.toString()');
  switch (lvl) {
    case Level.game:
      scene = GameWidget(game: Icarus(viewportResolution: Vector2(width, height)));
      break;
     case Level.shop:
       scene = ShopPage(Icarus(viewportResolution: Vector2(width, height)));
       break;
    case Level.mainMenu:
       scene = MainMenu(Icarus(viewportResolution: Vector2(width, height)));
       break;
    default:
      throw UnimplementedError('no widget for $lvl.toString()');
    }
  return LayoutBuilder(builder: (context,constraints){
      return Scaffold(body: scene);      
  }
  );
  }
}
