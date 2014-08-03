part of smartcanvas.svg;

class SvgDefLayerImpl {
  Layer _layer = new Layer(svg, {ID: '__svg_def_layer'});
  SvgLayer _impl;
  SVG.SvgElement _element;
  SVG.DefsElement _defsEl = new SVG.DefsElement();

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
  }

  void removeDef(Node defNode) {
    SVG.SvgElement defImplEl = _element.querySelector('#${defNode.id}');
    if (defImplEl != null) {
      num refCount = int.parse(defImplEl.dataset['refCount']);
      if (--refCount > 0) {
        defImplEl.dataset['refCount'] = refCount.toString();
      } else {
        defImplEl.remove();

        if (_defsEl.nodes.length == 0) {
          _defsEl.remove();
          _defsEl = null;
        }
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
      stage.addChild(impl._layer);
    }
    return impl;
  }
}