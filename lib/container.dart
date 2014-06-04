part of smartcanvas;

abstract class Container<T> {
  List<T> _children = new List<T>();
  Container() {}

  void addChild(T node);
  void removeChild(T node);
  void insertChild(int index, T node);
  void clearChildren();

  List<T> get children;
}