library smartcanvas;

// external dependencies
import 'dart:html' as DOM;
import 'dart:math';
//import 'dart:async';

//
//@MirrorsUsed(metaTargets: const [Group, SvgGroup, Circle, SvgCircle,
//                                 Ellipse, SvgEllipse, Line, SvgLine,
//                                 Path, SvgPath, Polygon, SvgPolygon,
//                                 Polyline, SvgPolyline, Rect, SvgRect,
//                                 Text, SvgText])
@MirrorsUsed(targets: const ['smartcanvas', 'smartcanvas.svg'], override: "*")
import 'dart:mirrors';

import 'package:dart_ext/dart_ext.dart';

import 'impl/svg/svg.dart';
import 'impl/canvas/canvas.dart';

part 'nodebase.dart';
part 'node.dart';
part 'container.dart';
part 'stage.dart';
part 'group.dart';
part 'layer.dart';
part 'pattern.dart';
part 'animation_loop.dart';

part 'event/event_handler.dart';
part 'event/event_bus.dart';

part 'reflection/reflection_node.dart';
part 'reflection/reflection_layer.dart';
part 'reflection/reflection_group.dart';
part 'reflection/reflection_if.dart';

part 'utils/position.dart';
part 'utils/constants.dart';
part 'utils/size.dart';
part 'utils/util.dart';
part 'utils/text_measure.dart';
part 'utils/bbox.dart';
part 'utils/transform_matrix.dart';

part 'shapes/circle.dart';
part 'shapes/ellipse.dart';
part 'shapes/rect.dart';
part 'shapes/line.dart';
part 'shapes/text.dart';
part 'shapes/polygon.dart';
part 'shapes/path.dart';
part 'shapes/polyline.dart';

part 'gradients/gradient.dart';
part 'gradients/linear_gradient.dart';
part 'gradients/radial_gradient.dart';

part 'impl/node_impl.dart';
part 'impl/layer_impl.dart';
