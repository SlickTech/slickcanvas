part of smartcanvas.canvas;

abstract class CanvasNode extends NodeImpl {

  CanvasNode(Node shell): super(shell) {}

  void remove() {
    if (parent != null) {
      (parent as Container).children.remove(this);
    }
    parent = null;
  }

  String get type => canvas;
}