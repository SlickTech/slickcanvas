library smartcanvas;

// external dependencies
import 'dart:html' as dom;
import 'dart:math';
import 'dart:svg' as svg;

import 'package:r2d2/r2d2_client.dart';
import 'package:dart_ext/collection_ext.dart';

import 'event/event_bus.dart';
import 'impl/svg/svg.dart';
import 'impl/canvas/canvas.dart';

part 'nodebase.dart';
part 'node.dart';
part 'utils/container.dart';
part 'stage.dart';
part 'group.dart';
part 'layer.dart';
part 'pattern.dart';
part 'animation_loop.dart';
part 'container_node.dart';

part 'reflection/reflection_layer.dart';

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
part 'shapes/poly_shape.dart';
part 'shapes/polygon.dart';
part 'shapes/path.dart';
part 'shapes/polyline.dart';
part 'shapes/image.dart';

part 'gradients/gradient.dart';
part 'gradients/linear_gradient.dart';
part 'gradients/radial_gradient.dart';

part 'impl/node_impl.dart';
part 'impl/layer_impl.dart';
