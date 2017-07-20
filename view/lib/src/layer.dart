import 'dart:html' as dom;
import 'package:slickcanvas_core/core.dart';
import 'stage.dart';

abstract class Layer {

  dom.Element get element;

  final matrix = new Matrix();

  Stage _stage;
  Stage get stage => _stage;
  void set stage (Stage value) {
    _stage = value;
  }
}