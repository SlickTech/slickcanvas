part of smartcanvas.canvas;

class CanvasText extends CanvasGraphNode {

  CanvasText(Text shell): super(shell) {
    shell.on('textChanged', _refresh);
  }

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

    List<String> parts = shell.partsOfWrappedText();

    if (fill != null) {
      if (fill is Gradient) {

      } else if (fill is SCPattern) {

      } else {
        context.fillStyle = shell.fill;
        for (num i = 0; i < parts.length; ++i) {
          context.fillText(parts[i], 0, shell.fontSize * i);
        }
      }
    }
  }

  void _strokeGraph([DOM.CanvasRenderingContext2D context]) {
    if (context == null) {
      context = _cacheContext;
    }

    List<String> parts = shell.partsOfWrappedText();

    if (stroke != null) {
      context.lineWidth = shell.strokeWidth.toDouble();
      context.strokeStyle = shell.stroke;
      for (num i = 0; i < parts.length; ++i) {
        context.strokeText(parts[i], 0, shell.fontSize * i);
      }
    }
  }

  Text get shell => super.shell;
}