part of smartcanvas.canvas;

class CanvasGroup extends CanvasGraphNode with Container<CanvasGraphNode> {

  Position _offset;

  CanvasGroup(Group shell) : super(shell) {
    if (getAttribute('useCache', false)) {
      _cacheCanvas = new dom.CanvasElement();
      _cacheContext = _cacheCanvas.context2D;

      _setElementAttributes();
      _setElementStyles();

      _cacheContext.scale(dom.window.devicePixelRatio, dom.window.devicePixelRatio);
      new Future.delayed(new Duration(seconds:0), () => _updateCache(true));
    }
  }

  @override
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    for (CanvasGraphNode child in children) {
      child.draw(0, 0, context);
    }
  }

  @override
  void _fillGraph(dom.CanvasRenderingContext2D context) {
  }

  @override
  void _stroketGraph(dom.CanvasRenderingContext2D context) {
  }

  void addChild(CanvasGraphNode node) {
    node.remove();
    node.parent = this;
    children.add(node);
    _update();
  }

  void insertChild(int index, CanvasGraphNode node) {
    node.remove();
    node.parent = this;
    children.insert(index, node);
    _update();
  }

  void removeChild(CanvasNode node) {
    node.remove();
    _update();
  }

  void clearChildren() {
    children.clear();
    _update();
  }

  void _update() {
    var bbx = getBBox(true);

    if (_cacheCanvas != null) {
      if (bbx.width != _cacheCanvas.width) {
        _cacheCanvas.style.width = '${bbx.width}px';
        _cacheCanvas.setAttribute(WIDTH, '${bbx.width * dom.window.devicePixelRatio}');
      }

      if (bbx.height != _cacheCanvas.height) {
        _cacheCanvas.style.height = '${bbx.height}px';
        _cacheCanvas.setAttribute(HEIGHT, '${bbx.height * dom.window.devicePixelRatio}');
      }
    }

    _refresh(true);
  }
}
