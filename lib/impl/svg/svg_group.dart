part of smartcanvas.svg;

class SvgGroup extends SvgNode implements Container<SvgNode> {
  List<SvgNode> _children = new List<SvgNode>();
  SvgGroup(Group shell): super(shell) {}

  SVG.SvgElement _createElement() {
    return new SVG.GElement();
  }

  void add(SvgNode child) {
    _children.add(child);
    child.parent = this;
    this._element.append(child._element);

    _addDefs();
  }

  void _addDefs() {
    if (layer != null) {
      _defs.forEach((def) {
        SvgNode defImpl = def.createImpl(svg);
        (layer as SvgLayer).addDef(def, defImpl);
      });
    }
  }

  void removeChild(SvgNode node) {
    node.parent = null;
    node.remove();
  }

  void removeChildren() {
    _children.forEach((child) => child.remove());
  }

  void insert(int index, SvgNode node) {
    node.parent = this;
    _children.insert(index, node);
    this._element.nodes.insert(index, node._element);
    _addDefs();
  }

  void _setElementAttribute(String attr) {
    super._setElementAttribute(attr);
    num x = attrs[X];
    num y = attrs[Y];
    bool b = false;
    if (x != null) {
      transformMatrix.tx = x;
      b = true;
    }

    if (y != null) {
      transformMatrix.ty = y;
      b = true;
    }

    if (b) {
      translate();
    }
  }

  List<SvgNode> get children => _children;

  String get _nodeName => SC_GROUP;
}