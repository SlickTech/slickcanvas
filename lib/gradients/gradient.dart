part of smartcanvas;

abstract class Gradient extends Node {

  Gradient(Map<String, dynamic> config): super(config) {}

  void set stops(List<num> value) => setAttribute(STOPS, value);
  List<num> get stops => getAttribute(STOPS, []);

  String get id => getAttribute(ID, '__sc_gradient_${uid}');
}