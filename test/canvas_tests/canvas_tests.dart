library smartcanvas.test.canvas;

import 'package:test/test.dart';
import 'package:smartcanvas/smartcanvas.dart';
import 'package:smartcanvas/impl/canvas/canvas.dart';
import '../test.dart';

part 'layer_tests.dart';

class CanvasTests {
  static void run() {
    group('canvas layer tests -', LayerTests.run);
  }
}