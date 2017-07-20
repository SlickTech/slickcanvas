library smartcanvas.test;

@TestOn("browser")

import 'package:test/test.dart';
import 'dart:html' as dom;
import 'package:slickcanvas/smartcanvas.dart';
import './svg_tests/svg_tests.dart';
import './canvas_tests/canvas_tests.dart';

Stage stage;

void main() {

  dom.Element container = dom.document.querySelector('#canvas');
  container.style.height = '800px';

  stage = new Stage(container, config: {
    WIDTH: 800,
    HEIGHT: 800,
  });

  SvgTests.run();
  CanvasTests.run();
}
