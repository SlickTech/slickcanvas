import "node.dart";
export "node.dart";

abstract class GraphNode extends Node {
  GraphNode([Map<String, dynamic> properties = const {}]) : super(properties);

  void set stroke(dynamic value) => setProperty('stroke', value);
  dynamic get stroke => getProperty('stroke');

  void set strokeWidth(num value) => setProperty('stroke-width', value);
  num get strokeWidth => getProperty('stroke-width', 1);

  void set strokeOpacity(num value) => setProperty('stroke-opacity', value);
  num get strokeOpacity => getProperty('stroke-opacity');

  void set strokeLinecap(String value) => setProperty('stroke-linecap', value);
  String get strokeLinecap => getProperty('stroke-linecap');

  void set strokeLineJoin(String value) =>
      setProperty('stroke-linejoin', value);
  String get strokeLineJoin => getProperty('stroke-linejoin');

  void set strokeDashArray(String value) =>
      setProperty('stroke-dasharray', value);
  String get strokeDashArray => getProperty('stroke-dasharray');

  @override
  BoundingBox get bbox {
    var pos = absolutePosition;
    return new BoundingBox(
        pos.x, pos.y, getProperty('width', 0), getProperty('height', 0));
  }
}
