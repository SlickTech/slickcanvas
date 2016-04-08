part of smartcanvas.canvas;

class CanvasEllipse extends CanvasGraphNode {
  CanvasEllipse(Ellipse shell): super(shell);

  @override
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    var ellipse = shell as Ellipse;

    context.beginPath();
    if (ellipse.rx != ellipse.ry) {
      context.save();
      context.scale(1, ellipse.ry / ellipse.rx);
      context.restore();
    }
    context.arc(0, 0, ellipse.rx, 0, PI * 2, false);
    context.closePath();
  }
}
