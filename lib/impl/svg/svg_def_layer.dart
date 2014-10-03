part of smartcanvas.svg;

class SvgDefLayerImpl {
  Layer _layer = new Layer(svg, {ID: '__svg_def_layer'});
  SvgLayer _impl;
  SVG.SvgElement _element;
  SVG.DefsElement _defsEl = new SVG.DefsElement();
  Map _suspendedDefs = {};

  SvgDefLayerImpl() {
    _impl = _layer.impl;
    _element = _impl.element;
    _impl.element.append(_defsEl);
  }

  void addDef(Node defNode) {
    SVG.SvgElement defImplEl = _element.querySelector('#${defNode.id}');
    if (defImplEl == null) {
      SvgNode defImpl = defNode.createImpl(svg);
      defImplEl = defImpl.element;
      _defsEl.append(defImpl.element);
      defImplEl.dataset['refCount'] = '1';
    } else {
      defImplEl.dataset['refCount'] = '${int.parse(defImplEl.dataset['refCount']) + 1}';
    }
    defNode.fire(DEF_ADDED);
  }

  void removeDef(Node defNode) {
    SVG.SvgElement defImplEl = _element.querySelector('#${defNode.id}');
    if (defImplEl != null) {
      num refCount = int.parse(defImplEl.dataset['refCount']);
      if (--refCount > 0) {
        defImplEl.dataset['refCount'] = refCount.toString();
      } else {
        defImplEl.remove();
      }
    }
  }

  void suspendDef(Node defNode) {
    String id = '${defNode.id}';
    if (!_suspendedDefs.containsKey(id)) {
      SVG.SvgElement defImplEl = _element.querySelector('#$id');
      if (defImplEl != null) {
        var dummy = defImplEl.clone(true);
        dummy.classes.add("dummy");
        _suspendedDefs[id] = defImplEl;
        defImplEl.replaceWith(dummy);
      }
    }
  }

  void resumeDef(Node defNode) {
    String id = '${defNode.id}';
    if (_suspendedDefs.containsKey(id)) {
      SVG.SvgElement dummy = _element.querySelector('#$id');
      if (dummy != null) {
        dummy.replaceWith(_suspendedDefs[id]);
        _suspendedDefs.remove(id);
      }
    }
  }
}

class SvgDefLayer {
  static Map<Stage, SvgDefLayerImpl> _impls = {};

  static SvgDefLayerImpl impl(Stage stage) {
    SvgDefLayerImpl impl = _impls[stage];
    if (impl == null) {
      impl = _impls[stage] = new SvgDefLayerImpl();
      stage.insertChild(0, impl._layer);
    }
    return impl;
  }
}