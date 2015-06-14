part of smartcanvas.canvas;

class CanvasLine extends CanvasGraphNode {
  CanvasLine(Line shell): super(shell);

  @override
  void _cacheGraph() {
  }

  @override
  void __drawGraph(dom.CanvasRenderingContext2D context) {
    context.beginPath();
    context.moveTo(shell.x1, shell.y1);
    context.lineTo(shell.x2, shell.y2);
    context.closePath();
  }

  @override
  Line get shell => super.shell;
}
