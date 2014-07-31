part of smartcanvas.canvas;

class CanvasEllipse extends CanvasGraphNode {
  CanvasEllipse(Ellipse shell): super(shell) {}

  void _cacheGraph() {}

  void __drawGraph(DOM.CanvasRenderingContext2D context) {
    context.beginPath();
    if(shell.rx != shell.ry) {
        context.scale(1, shell.ry / shell.rx);
    }
    context.arc(0, 0, shell.rx, 0, PI * 2, false);
    context.closePath();
  }

  Ellipse get shell => super.shell;
}

