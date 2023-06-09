import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../icarus.dart';

class ShopPage extends StatefulWidget {
    const ShopPage (this.game, {super.key});

    final Game game;

    @override
    State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
    @override
    Widget build(BuildContext context) {
        return const Text('Shop Page');
    }
}