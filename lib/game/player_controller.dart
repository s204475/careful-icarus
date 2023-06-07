import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:sensors_plus/sensors_plus.dart';

// main player 
class Controls extends PositionComponent with TapCallbacks, DragCallbacks {
  Controls() : super();

  @override
  void onTapUp(TapUpEvent event) {

  }

  @override
  void onTapDown(TapDownEvent event) {

  }

  @override
  void onLongTapDown(TapDownEvent event) {

  }

  @override
  void onTapCancel(TapCancelEvent event) {

  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {

  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
  }
}