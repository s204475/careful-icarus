import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

// main player
class PlayerControls extends PositionComponent with TapCallbacks, DragCallbacks {
  PlayerControls({super.position, super.size, super.priority}) : super(anchor: Anchor.center);
  
  @override
  Future<void> onLoad() async {
    debugPrint("loading playerControls");

  }

  @override
  void onTapUp(TapUpEvent event) {
    // to use an item
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    // setup UI to switch between items

    // start drag by saving the current position that is interacted
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // switch to next item
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    // select current item
  }
}