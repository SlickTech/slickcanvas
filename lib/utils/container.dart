part of smartcanvas;

abstract class Container<T> {
  final List<T> children = new List<T>();

  void addChild(T node);
  void removeChild(T node);
  void insertChild(int index, T node);
  void clearChildren();
}
