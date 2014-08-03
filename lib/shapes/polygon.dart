part of smartcanvas;

class Polygon extends Node{
  Polygon(Map<String, dynamic> config): super(config) {}

  NodeImpl _createSvgImpl(bool isReflection) {
    return new SvgPolygon(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }


  void set points(String value) => setAttribute(POINTS, value);
  List<num> getPsoints() {
    List<num> toReturn = [];
    String ps = getAttribute(POINTS);
    ps.split(COMMA).forEach((sNumber) {
      num p = double.parse(sNumber);
      toReturn.add(p);
    });
    return toReturn;
  }
}
