part of smartcanvas.canvas;

class CanvasPath extends CanvasGraphNode {

  CanvasPath(Path shell): super(shell) {
//    this._useCache = shell.pathSeg.length > 2;
  }

  void _cacheGraph() {
    Position currentAbsPos = new Position(x: shell.x, y: shell.y);
    _cacheContext.beginPath();
    shell.pathSeg.forEach((SVG.PathSeg seg) {
      _drawSeg(_cacheContext, seg, currentAbsPos);
    });
//    _cacheContext.closePath();
  }

  void __drawGraph(DOM.CanvasRenderingContext2D context) {
    Position currentAbsPos = new Position(x: shell.x, y: shell.y);
    context.beginPath();
    shell.pathSeg.forEach((SVG.PathSeg seg) {
      _drawSeg(context, seg, currentAbsPos);
    });
//    context.closePath();
  }

  void _drawSeg(DOM.CanvasRenderingContext2D context, SVG.PathSeg seg, Position currentAbsPos) {
    switch (seg.pathSegType) {
      case SVG.PathSeg.PATHSEG_ARC_ABS:
        break;
      case SVG.PathSeg.PATHSEG_ARC_REL:
        break;
      case SVG.PathSeg.PATHSEG_CLOSEPATH:
        context.closePath();
        break;
      case SVG.PathSeg.PATHSEG_CURVETO_CUBIC_ABS:
        break;
      case SVG.PathSeg.PATHSEG_CURVETO_CUBIC_REL:
        break;
      case SVG.PathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_ABS:
        break;
      case SVG.PathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_REL:
        break;
      case SVG.PathSeg.PATHSEG_CURVETO_QUADRATIC_ABS:
        break;
      case SVG.PathSeg.PATHSEG_CURVETO_QUADRATIC_REL:
        break;
      case SVG.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS:
        break;
      case SVG.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL:
        break;
      case SVG.PathSeg.PATHSEG_LINETO_ABS:
        SVG.PathSegLinetoAbs lSeg = seg;
        currentAbsPos
          ..x = lSeg.x
          ..y = lSeg.y;
        context.lineTo(currentAbsPos.x, currentAbsPos.y);
        break;
      case SVG.PathSeg.PATHSEG_LINETO_HORIZONTAL_ABS:
        currentAbsPos.x = (seg as SVG.PathSegLinetoHorizontalAbs).x;
        context.lineTo(currentAbsPos.x, currentAbsPos.y);
        break;
      case SVG.PathSeg.PATHSEG_LINETO_HORIZONTAL_REL:
        currentAbsPos.x += (seg as SVG.PathSegLinetoHorizontalRel).x;
        context.lineTo(currentAbsPos.y, currentAbsPos.y);
        break;
      case SVG.PathSeg.PATHSEG_LINETO_REL:
        SVG.PathSegLinetoRel lSeg = seg;
        currentAbsPos
        ..x += lSeg.x
        ..y += lSeg.y;
        context.lineTo(currentAbsPos.y, currentAbsPos.y);
        break;
      case SVG.PathSeg.PATHSEG_LINETO_VERTICAL_ABS:
        currentAbsPos.y = (seg as SVG.PathSegLinetoVerticalAbs).y;
        context.lineTo(currentAbsPos.y, currentAbsPos.y);
        break;
      case SVG.PathSeg.PATHSEG_LINETO_VERTICAL_REL:
        currentAbsPos.y += (seg as SVG.PathSegLinetoVerticalRel).y;
        context.lineTo(currentAbsPos.y, currentAbsPos.y);
        break;
      case SVG.PathSeg.PATHSEG_MOVETO_ABS:
        SVG.PathSegMovetoAbs MSeg = seg;
        context.moveTo(MSeg.x, MSeg.y);
        currentAbsPos
          ..x = MSeg.x
          ..y = MSeg.y;
        break;
      case SVG.PathSeg.PATHSEG_MOVETO_REL:
        SVG.PathSegMovetoRel mSeg = seg;
        currentAbsPos
          ..x += mSeg.x
          ..y += mSeg.y;
        context.moveTo(currentAbsPos.x, currentAbsPos.y);
        break;
    }
  }

  dynamic getAttribute(String attr, [dynamic defaultValue]) {
    switch(attr) {
      case X:
        return shell.x;
      case Y:
        return shell.y;
      case WIDTH:
        return shell.width;
      case HEIGHT:
        return shell.height;
      default:
        return super.getAttribute(attr, defaultValue);
    }
  }

  Path get shell => super.shell;
}