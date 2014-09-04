part of smartcanvas.canvas;

class CanvasLine extends CanvasGraphNode {
  CanvasLine(Line shell): super(shell) {}

  void _cacheGraph() {}

  void __drawGraph(DOM.CanvasRenderingContext2D context) {
    context.beginPath();
    context.moveTo(shell.x1, shell.y1);
    context.lineTo(shell.x2, shell.y2);
    context.closePath();
  }

  Line get shell => super.shell;
}