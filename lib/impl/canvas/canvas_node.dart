part of smartcanvas.canvas;

abstract class CanvasNode extends NodeImpl {

  List<CanvasTile> _tiles = [];

  CanvasNode(Node shell): super(shell);

  @override
  void on(String event, Function handler, [String id]) {}

  @override
  void remove() {
    var bbox = getBBox(true);
    for (CanvasTile tile in _tiles) {
      if (tile.children.contains(this)) {
        tile.children.remove(this);
        tile.nodeDirty(bbox);
        tile.draw();
      }
    }

    if (parent != null) {
      (parent as Container).removeChild(this);
    }
    parent = null;
    this._tiles.clear();
  }

  @override
  CanvasType get type => CanvasType.canvas;

  @override
  CanvasLayer get layer => (shell.layer)?.impl;
}
