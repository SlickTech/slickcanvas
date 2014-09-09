part of smartcanvas.canvas;

class CanvasCircle extends CanvasGraphNode {

  CanvasCircle(Circle shell): super(shell) {
    _useCache = false;
  }

  void _cacheGraph() {}

  void __drawGraph(DOM.CanvasRenderingContext2D context) {
    var r = getAttribute(R, 0);
    context.beginPath();
    context.arc(0, 0, r, 0, PI * 2, false);
    context.closePath();
  }

  Circle get shell => super.shell;

  num get width => (getAttribute(R, 0) + getAttribute(STROKE_WIDTH, 0)) * 2;
  num get height => (getAttribute(R, 0) + getAttribute(STROKE_WIDTH, 0)) * 2;
}