part of smartcanvas;

class Path extends Node {

  SvgPath _svgImpl;
  var _bbox = null;

  Path(Map<String, dynamic> config): super(config) {
    _svgImpl = _createSvgImpl(false);
    this.on('dChanged', () => _bbox = null);
  }

  NodeImpl _createSvgImpl(bool isReflection) {
    if (isReflection) {
      return new SvgPath(this, isReflection);
    } else if (_svgImpl == null) {
      _svgImpl = new SvgPath(this, isReflection);
    }
    return _svgImpl;
  }

  NodeImpl _createCanvasImpl() {
    return new CanvasPath(this);
  }

  List<SVG.PathSeg> get pathSeg {
    return _svgImpl.element.pathSegList;
  }

  BBox getBBox(bool isAbsolute) {
    if (this.stage != null) {
      if (_bbox != null) {
        var halfStrokeWidth = this.strokeWidth / 2;
        return new BBox(x: this.x + _bbox.x - halfStrokeWidth, y: this.y + _bbox.y - halfStrokeWidth,
            width: _bbox.width + this.strokeWidth, height: _bbox.height + this.strokeWidth);
      }

      var reflection = this.reflection;
      if (reflection == null) {
        reflection = _createReflection(this);
        this.stage._reflectionLayer.addChild(reflection as Node);
      }
      _bbox = ((reflection as Node).impl as SvgPath).element.getBBox();
      var rt = new BBox(x: this.x + _bbox.x, y: this.y + _bbox.y,
          width: _bbox.width, height: _bbox.height);

      if (this.reflection == null) {
        this.stage._reflectionLayer.removeChild(reflection);
      }
      return rt;
    }
    return new BBox();
  }

  void set d(String value) => setAttribute(D, value);
  String get d => getAttribute(D);

  num get width {
    var bbox = getBBox(true);
    return bbox.right;
  }

  num get height {
    var bbox = getBBox(true);
    return bbox.bottom;
  }
}