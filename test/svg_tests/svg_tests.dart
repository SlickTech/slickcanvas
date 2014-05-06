library smartcanvas.test.svg;

import 'package:unittest/unittest.dart';
import '../../lib/smartcanvas.dart';
import '../../lib/impl/svg/svg.dart';
import '../test.dart';

part 'gradient_tests.dart';
part 'layer_tests.dart';
part 'pattern_tests.dart';

class SvgTests {
  static void run() {
//    group('svg layer tests -', LayerTests.run);
    group('svg gradient tests -', SvgGradientTests.run);
//    group('svg pattern tests -', SvgPatternTests.run);
  }
}