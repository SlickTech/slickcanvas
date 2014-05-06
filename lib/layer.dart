part of smartcanvas;

class Layer extends Group {
  Stage _parent;
  LayerImpl _impl;
  String _type;

  Layer(this._type, Map<String, dynamic> config) : super(config) {
    _layer = this;
    _impl = createImpl(_type);
  }

  NodeImpl _createSvgImpl() {
    return  new SvgLayer(this);
  }

  NodeImpl _createCanvasImpl() {
    throw new CanvasLayer(this);
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
    _transformMatrix.tx = _parent._transformMatrix.tx;
    _transformMatrix.ty = _parent._transformMatrix.ty;
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
            (child._reflection as Node).remove();
          }
        });
      }

      _parent.children.remove(this);
      _parent = null;
    }
  }

  Layer get layer => this;

  String get type => _type;

  void set stage(Stage value) {
    _parent = value;
    _transformMatrix = _parent._transformMatrix;
    _parent
    .on('widthChanged', (oldValue, newValue) { width = newValue; })
    .on('heightChanged', (oldValue, newValue) { height = newValue; })
    ;
    fire('stageSet');
  }
  Stage get stage => _parent;

  num get width => getAttribute(WIDTH);
  num get height => getAttribute(HEIGHT);
}