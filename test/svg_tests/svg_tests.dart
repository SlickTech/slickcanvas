library smartcanvas.test;

import 'dart:html' as dom;
import 'package:unittest/unittest.dart';
import 'package:smartcanvas/smartcanvas.dart';

part 'gradient_tests.dart';

dom.DivElement container = new dom.DivElement();

Stage _stage = new Stage(container, svg, {
  WIDTH: container.clientWidth,
  HEIGHT: 900,
});

class SvgTests {
  static void run() {
    group('gradient tests', GradientTests.run);
  }
}