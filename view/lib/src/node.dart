import 'dart:html';
import 'package:slickcanvas_core/src/model.dart';

abstract class Node {
  final Model model;

  Node(this.model);

  ElementStream<MouseEvent> get onMouseDown;
  ElementStream<MouseEvent> get onMouseUp;
  ElementStream<MouseEvent> get onMouseOver;
  ElementStream<MouseEvent> get onMouseEnter;
  ElementStream<MouseEvent> get onMouseLeave;
  ElementStream<MouseEvent> get onMouseOut;
  ElementStream<MouseEvent> get onClick;
  ElementStream<MouseEvent> get onDoubleClick;
  ElementStream<MouseEvent> get onPanStart;
  ElementStream<MouseEvent> get onPanEnd;
  ElementStream<MouseEvent> get onPanning;
}