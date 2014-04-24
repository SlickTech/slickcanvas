library smartcanvas.test;

import 'dart:html' as dom;
import 'package:unittest/unittest.dart';

import '../lib/smartcanvas.dart';

part 'svg_tests/gradient_tests.dart';

Stage _stage;

void main() {
  dom.Element container = dom.document.querySelector('#canvas');

  _stage = new Stage(container, svg, {
    WIDTH: container.clientWidth,
    HEIGHT: 900,
  });

  GradientTests.run();
}