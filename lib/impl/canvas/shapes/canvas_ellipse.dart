part of smartcanvas.canvas;

class CanvasEllipse extends CanvasGraphNode {
  CanvasEllipse(Ellipse shell): super(shell);

  @override
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    context.beginPath();
    if (shell.rx != shell.ry) {
      context.save();
      context.scale(1, shell.ry / shell.rx);
      context.restore();
    }
    context.arc(0, 0, shell.rx, 0, PI * 2, false);
    context.closePath();
  }
}

