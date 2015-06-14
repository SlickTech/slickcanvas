part of smartcanvas.canvas;

class CanvasEllipse extends CanvasGraphNode {
  CanvasEllipse(Ellipse shell): super(shell);

  @override
  void _cacheGraph() {
  }

  @override
  void __drawGraph(dom.CanvasRenderingContext2D context) {
    context.beginPath();
    if (shell.rx != shell.ry) {
      context.scale(1, shell.ry / shell.rx);
    }
    context.arc(0, 0, shell.rx, 0, PI * 2, false);
    context.closePath();
  }

  @override
  Ellipse get shell => super.shell;
}

