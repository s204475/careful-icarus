import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';
import 'game/icarus.dart';
import 'game/util/util.dart';
import 'game/widgets/widgets.dart';
import 'game/widgets/main_menu.dart';
import 'game/widgets/shop_page.dart';
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

enum Level { game, mainMenu, shop }

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static Level lvl = Level.shop;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    var safeHeight = height - padding.top - padding.bottom;

    Widget scene = ShopPage(Icarus(viewportResolution: Vector2(width, height)));

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: scene,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: PopupMenuButton<int>(
            icon: const Icon(Icons.settings),
            onSelected: (item) {
              onSelected(context, item);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Icon(Icons.volume_off),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text("Quit to Menu"),
              ),
            ],
          ));
    });
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        setState(() {
          //kode der fjerner lyd fra appen
        });
        break;
      case 1:
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => MainMenu(Icarus(
                    viewportResolution: Vector2(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height)))),
          );
        });
        break;
    }
  }
}
