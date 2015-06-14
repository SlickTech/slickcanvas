part of smartcanvas.svg;

class SvgDefLayerImpl {

  static const String _refCount = 'refCount';

  final Layer _layer = new Layer(CanvasType.svg, {ID: '__svg_def_layer'});
  final svg.DefsElement _defsEl = new svg.DefsElement();
  final Map _suspendedDefs = {};

  SvgLayer _impl;
  svg.SvgElement _element;

  SvgDefLayerImpl() {
    _impl = _layer.impl;
    _element = _impl.element;
    _impl.element.append(_defsEl);
  }

  void addDef(Node defNode) {
    var defImplEl = _element.querySelector('#${defNode.id}');
    if (defImplEl == null) {
      SvgNode defImpl = defNode.createImpl(CanvasType.svg);
      defImplEl = defImpl.element;
      _defsEl.append(defImpl.element);
      defImplEl.dataset[_refCount] = '1';
    } else {
      defImplEl.dataset[_refCount] = '${int.parse(defImplEl.dataset[_refCount]) + 1}';
    }
    defNode.fire(defAdded);
  }

  void removeDef(Node defNode) {
    svg.SvgElement defImplEl = _element.querySelector('#${defNode.id}');
    if (defImplEl != null) {
      num refCnt = int.parse(defImplEl.dataset[_refCount]);
      if (--refCnt > 0) {
        defImplEl.dataset[_refCount] = refCnt.toString();
      } else {
        defImplEl.remove();
      }
    }
  }

  void suspendDef(Node defNode) {
    String id = '${defNode.id}';
    if (!_suspendedDefs.containsKey(id)) {
      svg.SvgElement defImplEl = _element.querySelector('#$id');
      if (defImplEl != null) {
        svg.SvgElement dummy = defImplEl.clone(true);
        dummy.classes.add("dummy");
        _suspendedDefs[id] = defImplEl;
        defImplEl.replaceWith(dummy);
      }
    }
  }

  void resumeDef(Node defNode) {
    String id = '${defNode.id}';
    if (_suspendedDefs.containsKey(id)) {
      svg.SvgElement dummy = _element.querySelector('#$id');
      if (dummy != null) {
        dummy.replaceWith(_suspendedDefs[id]);
        _suspendedDefs.remove(id);
      }
    }
  }
}

class SvgDefLayer {
  static final Map<Stage, SvgDefLayerImpl> _impls = {};

  static SvgDefLayerImpl impl(Stage stage) {
    var impl = _impls[stage];
    if (impl == null) {
      impl = _impls[stage] = new SvgDefLayerImpl();
      stage.insertChild(0, impl._layer);
    }
    return impl;
  }
}
