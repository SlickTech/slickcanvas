part of smartcanvas;

class Layer extends Group {
  Stage _parent;
  LayerImpl _impl;
  String _type;

  Layer(this._type, Map<String, dynamic> config) : super(config) {
    _layer = this;
    _impl = createImpl(_type);
  }

  NodeImpl _createSvgImpl([bool isReflection = false]) {
    return  new SvgLayer(this, isReflection);
  }

  NodeImpl _createCanvasImpl() {
    return new CanvasLayer(this);
  }

  Layer _clone() {
     return new Layer(_type, _attrs);
  }

  void suspend() {
    if (_impl != null) {
      _impl.suspend();
    }
  }

  void resume() {
    if (_impl != null) {
      _impl.resume();
    }
  }

  void _handleStageDragMove(e) {
    _transformMatrix.translateX = _parent._transformMatrix.translateX;
    _transformMatrix.translateY = _parent._transformMatrix.translateY;
    fire('translateChanged');
  }

  void remove() {
    if (_parent != null) {
      if (_impl != null) {
        _impl.remove();
      }

      if (_reflection != null) {
        _children.forEach((child) {
          if (child._reflection != null) {
            child._reflection.remove();
          }
        });
      }

      _parent.children.remove(this);
      String sUid = uid.toString();
      _parent
        .off('widthChanged', sUid)
        .off('heightChanged', sUid);
      _parent = null;
    }
  }

  Layer get layer => this;

  String get type => _type;

  void set stage(Stage value) {
    _parent = value;
    _transformMatrix = _parent._transformMatrix;

    String sUid = uid.toString();
    _parent
    .on('widthChanged', (newValue) { width = newValue; }, sUid)
    .on('heightChanged', (newValue) { height = newValue; }, sUid)
    ;
    fire('stageSet');
  }
  Stage get stage => _parent;

  num get width => getAttribute(WIDTH);
  num get height => getAttribute(HEIGHT);

  void set background(String value) => setAttribute(BACKGROUND, value);
  String get background => getAttribute(BACKGROUND);
}