library smartcanvas.svg;

import 'dart:html' as dom;
import 'dart:svg' as svg;
import 'dart:math';
import 'dart:async';
import 'package:dart_ext/collection_ext.dart';
import '../../event/event_bus.dart';

import '../../smartcanvas.dart';

part 'svg_node.dart';
part 'svg_group.dart';
part 'svg_layer.dart';
part 'svg_pattern.dart';
part 'svg_def_layer.dart';
part 'svg_container_node.dart';
part 'svg_draggable_node.dart';

part 'control_points/svg_control_point.dart';
part 'control_points/svg_n_control_point.dart';
part 'control_points/svg_s_control_point.dart';
part 'control_points/svg_w_control_point.dart';
part 'control_points/svg_e_control_point.dart';
part 'control_points/svg_nw_control_point.dart';
part 'control_points/svg_ne_control_point.dart';
part 'control_points/svg_sw_control_point.dart';
part 'control_points/svg_se_control_point.dart';

part 'shapes/svg_circle.dart';
part 'shapes/svg_rect.dart';
part 'shapes/svg_ellipse.dart';
part 'shapes/svg_line.dart';
part 'shapes/svg_text.dart';
part 'shapes/svg_poly_shape.dart';
part 'shapes/svg_polygon.dart';
part 'shapes/svg_path.dart';
part 'shapes/svg_polyline.dart';
part 'shapes/svg_image.dart';

part 'gradients/svg_gradient.dart';
part 'gradients/svg_linear_gradient.dart';
part 'gradients/svg_radial_gradient.dart';
