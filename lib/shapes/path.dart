part of smartcanvas;

class Path extends Node {

  SvgPath _svgImpl;
  var _bbox = null;

  Path([Map<String, dynamic> config = const {}]) : super(config) {
    _svgImpl = _createSvgImpl(false);
    this.on('dChanged', () => _bbox = null);
  }

  @override
  Node _clone(Map<String, dynamic> config) => new Path(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) {
    if (isReflection) {
      return new SvgPath(this, isReflection);
    } else if (_svgImpl == null) {
      _svgImpl = new SvgPath(this, isReflection);
    }
    return _svgImpl;
  }

  @override
  NodeImpl _createCanvasImpl() => new CanvasPath(this);

  List<svg.PathSeg> get pathSeg {
    svg.PathElement el = _svgImpl.element;
    if (el is svg.GElement) {
      // impl's reflection has control points
      el = el.children[0];
    }
    return el.pathSegList;
  }

  @override
  BBox getBBox(bool isAbsolute) {
    if (this.stage != null) {
      // TODO: improve it.

      var reflection = this.reflection;
      if (reflection == null) {
        if (_bbox != null) {
          // TODO: should recalculate?
          return _bbox;
        }

        reflection = this._createReflection();
        (stage._reflectionLayer.impl as SvgLayer).addChild(reflection);
      }

      var bbx = reflection.getBBox(isAbsolute);
      _bbox = new BBox(
        x: bbx.x,
        y: bbx.y,
        width: bbx.width * actualScaleX,
        height: bbx.height * actualScaleY
      );

      if (this.reflection == null) {
        reflection.remove();
      }
      return _bbox;
    }

    var pos = isAbsolute ? absolutePosition : position;
    return new BBox(
      x: pos.x,
      y: pos.y,
      width: getAttribute(WIDTH, 0) * actualScaleX,
      height: getAttribute(HEIGHT, 0) * actualScaleY
    );
  }

  void set d(String value) => setAttribute(D, value);
  String get d => getAttribute(D);

  @override
  num get width {
    var bbox = getBBox(true);
    return bbox.right - bbox.left;
  }

  @override
  num get height {
    var bbox = getBBox(true);
    return bbox.bottom;
  }
}
