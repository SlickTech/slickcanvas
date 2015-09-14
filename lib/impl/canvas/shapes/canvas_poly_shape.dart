part of smartcanvas.canvas;

class CanvasPolyShape extends CanvasGraphNode {

  CanvasPolyShape(shell):super(shell) {
    this._useCache = true;
  }

  void _draw(dom.CanvasRenderingContext2D context) {
    var points = shell.points;
    var origin = shell.origin;
    var offsetX = origin.x - shell.x;
    var offsetY = origin.y - shell.y;
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        context.moveTo(points[i].x + offsetX, points[i].y + offsetY);
      } else {
        context.lineTo(points[i].x + offsetX, points[i].y + offsetY);
      }
    }
  }

  @override
  void _cacheGraph() {
    _cacheContext.clearRect(0, 0, _cacheCanvas.width, _cacheCanvas.height);
    _cacheContext.imageSmoothingEnabled = false;
    _cacheContext.beginPath();

    _draw(_cacheContext);

//    _cacheContext.closePath();
  }

  @override
  dynamic getAttribute(String attr, [dynamic defaultValue]) {
    switch (attr) {
      case WIDTH:
        return shell.width;
      case HEIGHT:
        return shell.height;
      default:
        return super.getAttribute(attr, defaultValue);
    }
  }
}
