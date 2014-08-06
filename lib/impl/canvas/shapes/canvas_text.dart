part of smartcanvas.canvas;

class CanvasText extends CanvasGraphNode {
  CanvasText(Text shell): super(shell) {}

  void _cacheGraph() {}
  void __drawGraph(DOM.CanvasRenderingContext2D context) {
    context
        ..beginPath()
        ..font = shell.font;
//        ..textBaseline = shell.textBaseline
//        ..textAlign = shell.textAlign;
    context.closePath();
  }

  void _fillGraph([DOM.CanvasRenderingContext2D context]) {
    if (context == null) {
      context = _cacheContext;
    }

    if (fill != null) {
      if (fill is Gradient) {

      } else if (fill is SCPattern) {

      } else {
        context.fillStyle = shell.fill;
        context.fillText(shell.text, 0, 0);
      }
    }
  }

  void _strokeGraph([DOM.CanvasRenderingContext2D context]) {
    if (context == null) {
      context = _cacheContext;
    }

    if (stroke != null) {
      context.lineWidth = shell.strokeWidth.toDouble();
      context.strokeStyle = shell.stroke;
      context.strokeText(shell.text, 0, 0);
    }
  }
  Text get shell => super.shell;
}