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

  List<svg.PathSeg> get pathSeg => _svgImpl.element.pathSegList;

  @override
  BBox getBBox(bool isAbsolute) {
    if (this.stage != null) {
      if (_bbox != null) {
        var halfStrokeWidth = this.strokeWidth / 2;
        return new BBox(x: this.x + _bbox.x - halfStrokeWidth, y: this.y + _bbox.y - halfStrokeWidth,
        width: _bbox.width + this.strokeWidth, height: _bbox.height + this.strokeWidth);
      }

      var reflection = this.reflection;
      if (reflection == null) {
        reflection = this._createReflection();
        (stage._reflectionLayer.impl as SvgLayer).addChild(reflection);
      }
      _bbox = (reflection as SvgPath).element.getBBox();
      var rt = new BBox(x: this.x + _bbox.x, y: this.y + _bbox.y,
      width: _bbox.width, height: _bbox.height);

      if (this.reflection == null) {
        reflection.remove();
      }
      return rt;
    }
    return new BBox(x: this.x, y: this.y, width: getAttribute(WIDTH, 0), height: getAttribute(HEIGHT, 0));
  }

  void set d(String value) => setAttribute(D, value);
  String get d => getAttribute(D);

  @override
  num get width {
    var bbox = getBBox(true);
    return bbox.right;
  }

  @override
  num get height {
    var bbox = getBBox(true);
    return bbox.bottom;
  }
}
