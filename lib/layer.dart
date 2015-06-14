part of smartcanvas;

class Layer extends Group {
  Stage _stage;
  final CanvasType type;

  Layer(this.type, [Map<String, dynamic> config = const {}]) : super(config) {
    _impl = createImpl(type);
  }

  @override
  Node _createNewInstance(Map<String, dynamic> config) => new Layer(this.type, config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) => new SvgLayer(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasLayer(this);

  void suspend() {
    if (_impl != null) {
      (_impl as LayerImpl).suspend();
    }
  }

  void resume() {
    if (_impl != null) {
      (_impl as LayerImpl).resume();
    }
  }

  @override
  void remove() {
    if (_stage != null) {
      if (_impl != null) {
        _impl.remove();
      }

      if (_reflection != null) {
        children.forEach((child) {
          if (child._reflection != null) {
            child._reflection.remove();
          }
        });
      }

      _stage.children.remove(this);
      var sUid = uid.toString();
      _stage
        ..off('widthChanged', sUid)
        ..off('heightChanged', sUid);
      _stage = null;
    }
  }

  @override
  Layer get layer => this;

  @override
  LayerImpl get impl => _impl;

  void set stage(Stage value) {
    _stage = value;
    _transformMatrix = _stage._transformMatrix;

    var sUid = uid.toString();
    _stage
      ..on('widthChanged', (newValue) {
      width = newValue;
    }, sUid)
      ..on('heightChanged', (newValue) {
      height = newValue;
    }, sUid);
    fire('stageSet');
  }

  Stage get stage => _stage;

  @override
  num get width => getAttribute(WIDTH);

  @override
  num get height => getAttribute(HEIGHT);

  void set background(String value) => setAttribute(BACKGROUND, value);
  String get background => getAttribute(BACKGROUND);
}
