part of smartcanvas.canvas;

class _EllipticalArcParam {
  num cx;
  num cy;
  num rx;
  num ry;
  num theta;
  num dTheta;
  num angle;
  bool fs;

  _EllipticalArcParam({this.cx: 0, this.cy: 0, this.rx: 0, this.ry: 0,
                      this.theta: 0, this.dTheta: 0, this.angle: 0, this.fs: false});
}

class CanvasPath extends CanvasGraphNode {

  CanvasPath(Path shell): super(shell);

  @override
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    var currentAbsPos = new Position(x: shell.x, y: shell.y);
    List<Map<svg.PathSeg, Position>> preSegs = [];

    context.beginPath();
    path.pathSeg.forEach((svg.PathSeg seg) {
      _drawSeg(context, seg, preSegs, currentAbsPos);
      preSegs.add({seg: currentAbsPos});
    });
    context.closePath();
  }

  void _drawSeg(dom.CanvasRenderingContext2D context, svg.PathSeg seg, List<Map<svg.PathSeg, Position>> preSegs,
                Position currentAbsPos) {
    switch (seg.pathSegType) {
      case svg.PathSeg.PATHSEG_ARC_ABS:
        svg.PathSegArcAbs aSeg = seg;

        _drawEllipticalArc(context, currentAbsPos.x, currentAbsPos.y, aSeg.x,
        aSeg.y, aSeg.largeArcFlag, aSeg.sweepFlag, aSeg.r1, aSeg.r2, aSeg.angle);

        currentAbsPos
          ..x = aSeg.x
          ..y = aSeg.y;
        break;

      case svg.PathSeg.PATHSEG_ARC_REL:
        svg.PathSegArcRel arSeg = seg;

        num x1 = currentAbsPos.x;
        num y1 = currentAbsPos.y;

        currentAbsPos
          ..x += arSeg.x
          ..y += arSeg.y;

        _drawEllipticalArc(context, x1, y1, currentAbsPos.x,
        currentAbsPos.y, arSeg.largeArcFlag,
        arSeg.sweepFlag, arSeg.r1, arSeg.r2,
        arSeg.angle);
        break;

      case svg.PathSeg.PATHSEG_CLOSEPATH:
        context.closePath();
        break;

      case svg.PathSeg.PATHSEG_CURVETO_CUBIC_ABS:
        svg.PathSegCurvetoCubicAbs ccaSeg = seg;
        context.bezierCurveTo(ccaSeg.x1, ccaSeg.y1, ccaSeg.x2, ccaSeg.y2, ccaSeg.x, ccaSeg.y);
        currentAbsPos
          ..x = ccaSeg.x
          ..y = ccaSeg.y;
        break;

      case svg.PathSeg.PATHSEG_CURVETO_CUBIC_REL:
        svg.PathSegCurvetoCubicRel ccrSeg = seg;
        num cx = currentAbsPos.x;
        num cy = currentAbsPos.y;
        currentAbsPos
          ..x += ccrSeg.x
          ..y += ccrSeg.y;

        context.bezierCurveTo(ccrSeg.x1 + cx, ccrSeg.y1 + cy, ccrSeg.x2 + cx, ccrSeg.y2 + cy,
        currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_ABS:
        svg.PathSegCurvetoCubicSmoothAbs ccsaSeg = seg;

        num x1 = currentAbsPos.x, y1 = currentAbsPos.y;

        // The first control point is assumed to be the reflection of the second control point on
        // the previous command relative to the current point. (If there is no previous command or
        // if the previous command was not an C, c, S or s, assume the first control point is
        // coincident with the current point.)

        if (preSegs.isNotEmpty) {
          var preSeg = preSegs.last.keys.elementAt(0);

          switch (preSeg.pathSegType) {
            case svg.PathSeg.PATHSEG_CURVETO_CUBIC_ABS:
              svg.PathSegCurvetoCubicAbs preCCAbsSeg = preSeg;
              x1 += currentAbsPos.x - preCCAbsSeg.x2;
              y1 += currentAbsPos.y - preCCAbsSeg.y2;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_CUBIC_REL:
              svg.PathSegCurvetoCubicRel preCCRelSeg = preSeg;
              x1 += currentAbsPos.x - preCCRelSeg.x2;
              y1 += currentAbsPos.y - preCCRelSeg.y2;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_ABS:
              svg.PathSegCurvetoCubicSmoothAbs preCCSAbsSeg = preSeg;
              x1 += currentAbsPos.x - preCCSAbsSeg.x2;
              y1 += currentAbsPos.y - preCCSAbsSeg.y2;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_REL:
              svg.PathSegCurvetoCubicSmoothRel preCCSRelSeg = preSeg;
              x1 += currentAbsPos.x - preCCSRelSeg.x2;
              y1 += currentAbsPos.y - preCCSRelSeg.y2;
              break;
          }
        }

        context.bezierCurveTo(x1, y1, ccsaSeg.x2, ccsaSeg.y2, ccsaSeg.x, ccsaSeg.y);
        currentAbsPos
          ..x = ccsaSeg.x
          ..y = ccsaSeg.y;
        break;

      case svg.PathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_REL:
        svg.PathSegCurvetoCubicSmoothRel ccsrSeg = seg;
        num cx = currentAbsPos.x, cy = currentAbsPos.y;
        num x1 = cx, y1 = cy;

        // The first control point is assumed to be the reflection of the second control point on
        // the previous command relative to the current point. (If there is no previous command or
        // if the previous command was not an C, c, S or s, assume the first control point is
        // coincident with the current point.)

        if (preSegs.isNotEmpty) {

          var preSeg = preSegs.last.keys.elementAt(0);

          switch (preSeg.pathSegType) {
            case svg.PathSeg.PATHSEG_CURVETO_CUBIC_ABS:
              svg.PathSegCurvetoCubicAbs preCCAbsSeg = preSeg;
              x1 += currentAbsPos.x - preCCAbsSeg.x2;
              y1 += currentAbsPos.y - preCCAbsSeg.y2;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_CUBIC_REL:
              svg.PathSegCurvetoCubicRel preCCRelSeg = preSeg;
              // TODO: should calc relative x2, y2?
              x1 += currentAbsPos.x - preCCRelSeg.x2;
              y1 += currentAbsPos.y - preCCRelSeg.y2;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_ABS:
              svg.PathSegCurvetoCubicSmoothAbs preCCSAbsSeg = preSeg;
              x1 += currentAbsPos.x - preCCSAbsSeg.x2;
              y1 += currentAbsPos.y - preCCSAbsSeg.y2;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_REL:
              svg.PathSegCurvetoCubicSmoothRel preCCSRelSeg = preSeg;
              // TODO: should calc relative x2, y2?
              x1 += currentAbsPos.x - preCCSRelSeg.x2;
              y1 += currentAbsPos.y - preCCSRelSeg.y2;
              break;
          }
        }

        currentAbsPos
          ..x += ccsrSeg.x
          ..y += ccsrSeg.y;

        context.bezierCurveTo(x1, y1, cx + ccsrSeg.x2, cy + ccsrSeg.y2, currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_ABS:
        svg.PathSegCurvetoQuadraticAbs cqSeg = seg;
        context.quadraticCurveTo(cqSeg.x1, cqSeg.y1, cqSeg.x, cqSeg.y);
        currentAbsPos
          ..x = cqSeg.x
          ..y = cqSeg.y;
        break;

      case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_REL:
        svg.PathSegCurvetoQuadraticRel cqrSeg = seg;
        num x1 = currentAbsPos.x, y1 = currentAbsPos.y;
        currentAbsPos
          ..x += cqrSeg.x
          ..y += cqrSeg.y;
        context.quadraticCurveTo(cqrSeg.x1 + x1, cqrSeg.y1 + y1, currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS:
        svg.PathSegCurvetoQuadraticSmoothAbs cqsSeg = seg;

        num x1 = currentAbsPos.x, y1 = currentAbsPos.y;

        // The control point is assumed to be the reflection of the control point on the previous
        // command relative to the current point. (If there is no previous command or if the previous
        // command was not a Q, q, T or t, assume the control point is coincident with the current point.)

        if (preSegs.isNotEmpty) {
          var preSeg = preSegs.last.keys.elementAt(0);

          switch (preSeg.pathSegType) {
            case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_ABS:
              svg.PathSegCurvetoQuadraticAbs preCQAbsSeg = preSeg;
              x1 += currentAbsPos.x - preCQAbsSeg.x1;
              y1 += currentAbsPos.y - preCQAbsSeg.y1;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_REL:
              svg.PathSegCurvetoQuadraticRel preCQRelSeg = preSeg;
              // TODO: should calc relative x1, y1?
              x1 += currentAbsPos.x - preCQRelSeg.x1;
              y1 += currentAbsPos.y - preCQRelSeg.y1;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS:
              if (preSegs.length > 1) {
                var prePos = _getPreQuadraticSmoothControlPoint(preSegs.length - 2, preSegs);
                if (prePos != null) {
                  x1 += currentAbsPos.x - prePos[0];
                  y1 += currentAbsPos.y - prePos[1];
                }
              }
              break;
            case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL:
              if (preSegs.length > 1) {
                var prePos = _getPreQuadraticSmoothControlPoint(preSegs.length - 2, preSegs);
                if (prePos != null) {
                  x1 += currentAbsPos.x - prePos[0];
                  y1 += currentAbsPos.y - prePos[1];
                }
              }
              break;
          }
        }


        context.quadraticCurveTo(x1, y1, cqsSeg.x, cqsSeg.y);
        currentAbsPos
          ..x = cqsSeg.x
          ..y = cqsSeg.y;
        break;

      case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL:
        svg.PathSegCurvetoQuadraticSmoothRel cqsrSeg = seg;

        num x1 = currentAbsPos.x, y1 = currentAbsPos.y;

        // The control point is assumed to be the reflection of the control point on the previous
        // command relative to the current point. (If there is no previous command or if the previous
        // command was not a Q, q, T or t, assume the control point is coincident with the current point.)

        if (preSegs.isNotEmpty) {
          var preSeg = preSegs.last.keys.elementAt(0);

          switch (preSeg.pathSegType) {
            case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_ABS:
              svg.PathSegCurvetoQuadraticAbs preCQAbsSeg = preSeg;
              x1 += currentAbsPos.x - preCQAbsSeg.x1;
              y1 += currentAbsPos.y - preCQAbsSeg.y1;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_REL:
              svg.PathSegCurvetoQuadraticRel preCQRelSeg = preSeg;
              // TODO: should calc relative x1, y1?
              x1 += currentAbsPos.x - preCQRelSeg.x1;
              y1 += currentAbsPos.y - preCQRelSeg.y1;
              break;
            case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS:
              if (preSegs.length > 1) {
                var prePos = _getPreQuadraticSmoothControlPoint(preSegs.length - 2, preSegs);
                if (prePos != null) {
                  x1 += currentAbsPos.x - prePos[0];
                  y1 += currentAbsPos.y - prePos[1];
                }
              }
              break;
            case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL:
              if (preSegs.length > 1) {
                var prePos = _getPreQuadraticSmoothControlPoint(preSegs.length - 2, preSegs);
                if (prePos != null) {
                  x1 += currentAbsPos.x - prePos[0];
                  y1 += currentAbsPos.y - prePos[1];
                }
              }
              break;
          }
        }

        currentAbsPos
          ..x += cqsrSeg.x
          ..y += cqsrSeg.y;

        context.quadraticCurveTo(x1, y1, currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_LINETO_ABS:
        svg.PathSegLinetoAbs lSeg = seg;
        currentAbsPos
          ..x = lSeg.x
          ..y = lSeg.y;
        context.lineTo(currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_LINETO_HORIZONTAL_ABS:
        currentAbsPos.x = (seg as svg.PathSegLinetoHorizontalAbs).x;
        context.lineTo(currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_LINETO_HORIZONTAL_REL:
        currentAbsPos.x += (seg as svg.PathSegLinetoHorizontalRel).x;
        context.lineTo(currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_LINETO_REL:
        svg.PathSegLinetoRel lSeg = seg;
        currentAbsPos
          ..x += lSeg.x
          ..y += lSeg.y;
        context.lineTo(currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_LINETO_VERTICAL_ABS:
        currentAbsPos.y = (seg as svg.PathSegLinetoVerticalAbs).y;
        context.lineTo(currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_LINETO_VERTICAL_REL:
        currentAbsPos.y += (seg as svg.PathSegLinetoVerticalRel).y;
        context.lineTo(currentAbsPos.x, currentAbsPos.y);
        break;

      case svg.PathSeg.PATHSEG_MOVETO_ABS:
        svg.PathSegMovetoAbs MSeg = seg;
        context.moveTo(MSeg.x, MSeg.y);
        currentAbsPos
          ..x = MSeg.x
          ..y = MSeg.y;
        break;

      case svg.PathSeg.PATHSEG_MOVETO_REL:
        svg.PathSegMovetoRel mSeg = seg;
        currentAbsPos
          ..x += mSeg.x
          ..y += mSeg.y;
        context.moveTo(currentAbsPos.x, currentAbsPos.y);
        break;
    }
  }

  List<num> _getPreQuadraticSmoothControlPoint(int index, List<Map<svg.PathSeg, Position>> preSegs) {
    svg.PathSeg seg;
    Position prePos;

    // index is >= 0
    for (int i = index; i >= 0; i--) {
      seg = preSegs[i].keys.elementAt(0);
      prePos = preSegs[i].values.elementAt(0);

      switch (seg.pathSegType) {
        case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_ABS:
          svg.PathSegCurvetoQuadraticAbs cqaSeg = seg;
          return [prePos.x + prePos.x - cqaSeg.x1, prePos.y + prePos.y - cqaSeg.y1];
        case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_REL:
          svg.PathSegCurvetoQuadraticRel cqrSeg = seg;
          // TODO: should calc relative x1, y1?
          return [prePos.x + prePos.x - cqrSeg.x1, prePos.y + prePos.y - cqrSeg.y1];
        case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS:
        case svg.PathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL:
          if (i > 0) {
            return _getPreQuadraticSmoothControlPoint(i - 1, preSegs);
          }
          return [prePos.x, prePos.y];
        default:
          return [prePos.x, prePos.y];
      }
    }
    return null;
  }

  _EllipticalArcParam _convertEndpointToCenterParameterization(num x1, num y1, num x2, num y2,
                                                               bool largeArcFlag, bool sweepFlag,
                                                               num rx, num ry, num angle) {
//        Derived from: http://www.w3.org/TR/SVG/implnote.html#ArcImplementationNotes
    var psi = angle * (PI / 180.0);
    var xp = cos(psi) * (x1 - x2) / 2.0 + sin(psi) * (y1 - y2) / 2.0;
    var yp = -1 * sin(psi) * (x1 - x2) / 2.0 + cos(psi) * (y1 - y2) / 2.0;

    var lambda = (xp * xp) / (rx * rx) + (yp * yp) / (ry * ry);

    if (lambda > 1) {
      rx *= sqrt(lambda);
      ry *= sqrt(lambda);
    }

    var f = sqrt((((rx * rx) * (ry * ry)) - ((rx * rx) * (yp * yp)) - ((ry * ry) * (xp * xp))) / ((rx * rx) * (yp * yp) + (ry * ry) * (xp * xp)));

    if (largeArcFlag == sweepFlag) {
      f *= -1;
    }
    if (f.isNaN) {
      f = 0.0;
    }

    var cxp = f * rx * yp / ry;
    var cyp = f * -ry * xp / rx;

    var cx = (x1 + x2) / 2.0 + cos(psi) * cxp - sin(psi) * cyp;
    var cy = (y1 + y2) / 2.0 + sin(psi) * cxp + cos(psi) * cyp;

    Function vMag = (v) {
      return sqrt(v[0] * v[0] + v[1] * v[1]);
    };

    Function vRatio = (u, v) {
      return (u[0] * v[0] + u[1] * v[1]) / (vMag(u) * vMag(v));
    };
    Function vAngle = (u, v) {
      return (u[0] * v[1] < u[1] * v[0] ? -1 : 1) * acos(vRatio(u, v));
    };
    var theta = vAngle([1, 0], [(xp - cxp) / rx, (yp - cyp) / ry]);
    var u = [(xp - cxp) / rx, (yp - cyp) / ry];
    var v = [(-1 * xp - cxp) / rx, (-1 * yp - cyp) / ry];
    var dTheta = vAngle(u, v);

    if (vRatio(u, v) <= -1) {
      dTheta = PI;
    }
    if (vRatio(u, v) >= 1) {
      dTheta = 0;
    }
    if (sweepFlag == false && dTheta > 0) {
      dTheta = dTheta - 2 * PI;
    }
    if (sweepFlag == true && dTheta < 0) {
      dTheta = dTheta + 2 * PI;
    }

    return new _EllipticalArcParam(cx:cx, cy:cy, rx:rx, ry:ry, theta:theta,
    dTheta:dTheta, angle:psi, fs:sweepFlag);
  }

  void _drawEllipticalArc(dom.CanvasRenderingContext2D context, num x1, num y1,
                          num x2, num y2, bool largArcFlag, bool sweepflag,
                          num r1, num r2, num angle) {
    _EllipticalArcParam param = _convertEndpointToCenterParameterization(x1, y1, x2, y2,
    largArcFlag, sweepflag, r1, r2, angle);

    var cx = param.cx, cy = param.cy, rx = param.rx, ry = param.ry,
    theta = param.theta, dTheta = param.dTheta, psi = param.angle, fs = param.fs;

    var r = (rx > ry) ? rx : ry;
    var scaleX = (rx > ry) ? 1 : rx / ry;
    var scaleY = (rx > ry) ? ry / rx : 1;

    context.translate(cx, cy);
    context.rotate(psi);
    context.scale(scaleX, scaleY);
    context.arc(0, 0, r, theta, theta + dTheta, !fs);
    context.scale(1 / scaleX, 1 / scaleY);
    context.rotate(-psi);
    context.translate(-cx, -cy);
  }

  @override
  dynamic getAttribute(String attr, [dynamic defaultValue]) {
    switch (attr) {
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

  Path get path => shell as Path;
}
