library smartcanvas.test.canvas;

import 'package:unittest/unittest.dart';
import '../../lib/smartcanvas.dart';
import '../test.dart';

part 'layer_tests.dart';

class CanvasTests {
  static void run() {
    group('svg layer tests -', LayerTests.run);
  }
}