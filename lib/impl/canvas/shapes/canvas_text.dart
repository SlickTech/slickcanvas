part of smartcanvas.canvas;

class CanvasText extends CanvasGraphNode {

  CanvasText(Text shell): super(shell) {
    shell.on('textChanged', _refresh);
  }

  @override
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    context
      ..beginPath()
      ..font = text.font
//      ..textBaseline = 'bottom' //text.textBaseline
      ..closePath()
    ;
  }

  void _fillGraph([dom.CanvasRenderingContext2D context]) {
    if (context == null) {
      context = _cacheContext;
    }

    List<String> parts = text.partsOfWrappedText();

    if (fill != null) {
      if (fill is Gradient) {

      } else if (fill is SCPattern) {

      } else {
        context.fillStyle = shell.fill;
        for (num i = 0; i < parts.length; ++i) {
          context.fillText(parts[i], 0, text.fontSize * i);
        }
      }
    }
  }

  void _strokeGraph([dom.CanvasRenderingContext2D context]) {
    if (context == null) {
      context = _cacheContext;
    }

    List<String> parts = text.partsOfWrappedText();

    if (stroke != null) {
      context.lineWidth = shell.strokeWidth.toDouble();
      context.strokeStyle = shell.stroke;
      for (num i = 0; i < parts.length; ++i) {
        context.strokeText(parts[i], 0, text.fontSize * i);
      }
    }
  }

  Text get text => shell as Text;
}
