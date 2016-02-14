part of smartcanvas.canvas;

class CanvasPolyShape extends CanvasGraphNode {

  CanvasPolyShape(shell):super(shell);

  void _draw(dom.CanvasRenderingContext2D context) {
    var ployShape = shell as PolyShape;

    var points = ployShape.points;
    var origin = ployShape.origin;
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
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    context.imageSmoothingEnabled = false;
    context.beginPath();
    _draw(context);
    context.closePath();
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
