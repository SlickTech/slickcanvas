import 'dart:html';
import 'dart:svg' as svg;
import 'package:slickcanvas_view/view.dart';

class SvgLayer extends Layer {
  final _element = new svg.SvgSvgElement();

  @override
  Element get element => _element;

  @override
  void set stage(Stage value) {
    super.stage = value;
    width = stage.width;
    height = stage.height;
  }

  num get width => num.parse(_element.attributes['width']);

  void set width(num value) {
    _element.attributes['width'] = '$value';
    _element.viewBox.baseVal.width =
        value / (matrix.scaleXValue * stage.matrix.scaleXValue);
  }

  num get height => num.parse(_element.attributes['height']);

  void set height(num value) {
    _element.attributes['height'] = '${stage.height}';
    _element.viewBox.baseVal.height =
        value / (matrix.scaleYValue * stage.matrix.scaleYValue);
  }
}
