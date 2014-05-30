library smartcanvas.test.canvas;

import 'package:unittest/unittest.dart';
import '../../lib/smartcanvas.dart';
import '../../lib/impl/canvas/canvas.dart';
import '../test.dart';

part 'layer_tests.dart';

class CanvasTests {
  static void run() {
    group('canvas layer tests -', LayerTests.run);
  }
}