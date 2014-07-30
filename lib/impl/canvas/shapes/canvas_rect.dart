part of smartcanvas.canvas;

class CanvasRect extends CanvasGraphNode {
  CanvasRect(Rect shell): super(shell) {
    _useCache = !(shell.rx == null && shell.ry == null);

    shell.on('rxChanged, ryChanged', (oldValue, newValue) {
      if (newValue != null) {
        _useCache = true;
        _cacheGraph();
      }
    });
  }

  void _cacheGraph() {
    if (shell.rx == null && shell.ry == null) {
      _cacheContext.beginPath();
      _cacheContext.rect(0, 0, width, height);
      _cacheContext.closePath();
      return;
    }

    if (shell.rx == null) {
      shell.rx = shell.ry;
    } else if (shell.ry == null) {
      shell.ry = shell.rx;
    }

    // arcTo would be nicer, but browser support is patchy (Opera)
    _cacheContext.beginPath();
    _cacheContext.moveTo(shell.rx.toDouble(), 0);
    _cacheContext.lineTo((width - shell.rx).toDouble(), 0);
    _cacheContext.arc(width - shell.rx, shell.ry, shell.ry, PI * 3 / 2, 0, false);
    _cacheContext.lineTo(width, height - shell.ry);
    _cacheContext.arc(width - shell.rx, height - shell.ry, shell.rx, 0, PI / 2, false);
    _cacheContext.lineTo(shell.rx, height);
    _cacheContext.arc(shell.rx, height - shell.ry, shell.ry, PI / 2, PI, false);
    _cacheContext.lineTo(0, shell.ry);
    _cacheContext.arc(shell.rx, shell.ry, shell.rx, PI, PI * 3 / 2, false);
    _cacheContext.closePath();
  }

  void __drawGraph(DOM.CanvasRenderingContext2D context) {
    context.beginPath();
    context.rect(0, 0, width, height);
    context.closePath();
  }

  Rect get shell => super.shell;
}