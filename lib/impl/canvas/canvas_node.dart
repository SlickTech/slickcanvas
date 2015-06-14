part of smartcanvas.canvas;

abstract class CanvasNode extends NodeImpl {

  List<CanvasTile> _tiles = [];

  CanvasNode(Node shell): super(shell);

  @override
  void on(String event, Function handler, [String id]) {}

  @override
  void remove() {
    if (parent != null) {
      if (parent is CanvasLayer) {
        layer._tiles.forEach((tile) {
          if (tile.children.contains(this)) {
            tile.children.remove(this);
          }
        });
      }
      (parent as Container).children.remove(this);
    }
    parent = null;
    this._tiles.clear();
  }

  @override
  CanvasType get type => CanvasType.canvas;

  @override
  CanvasLayer get layer => super.layer;
}
