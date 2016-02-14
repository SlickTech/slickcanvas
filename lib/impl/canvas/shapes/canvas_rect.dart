part of smartcanvas.canvas;

class CanvasRect extends CanvasGraphNode {
  CanvasRect(Rect shell): super(shell) {
    shell.on('rxChanged, ryChanged', (newValue) => _cacheGraph());
  }

  @override
  void _cacheGraph() {
  }

  @override
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    if (rect.rx == null) {
      rect.rx = rect.ry;
    } else if (rect.ry == null) {
      rect.ry = rect.rx;
    }

    context.beginPath();
    if (rect.rx == null) {
      context.rect(0, 0, width, height);
    } else {
      // arcTo would be nicer, but browser support is patchy (Opera)
      context.moveTo(rect.rx.toDouble(), 0);
      context.lineTo((width - rect.rx).toDouble(), 0);
      context.arc(width - rect.rx, rect.ry, rect.ry, PI * 3 / 2, 0, false);
      context.lineTo(width, height - rect.ry);
      context.arc(width - rect.rx, height - rect.ry, rect.rx, 0, PI / 2, false);
      context.lineTo(rect.rx, height);
      context.arc(rect.rx, height - rect.ry, rect.ry, PI / 2, PI, false);
      context.lineTo(0, rect.ry);
      context.arc(rect.rx, rect.ry, rect.rx, PI, PI * 3 / 2, false);
    }
    context.closePath();
  }

  Rect get rect => shell as Rect;
}
