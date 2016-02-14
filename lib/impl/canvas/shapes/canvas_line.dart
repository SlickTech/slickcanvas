part of smartcanvas.canvas;

class CanvasLine extends CanvasGraphNode {
  CanvasLine(Line shell): super(shell);

  @override
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    var line = shell as Line;
    context.beginPath();
    context.moveTo(line.x1, line.y1);
    context.lineTo(line.x2, line.y2);
    context.closePath();
  }
}
