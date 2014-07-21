part of smartcanvas.svg;

class SvgGroup extends SvgNode implements Container<SvgNode> {
  List<SvgNode> _children = new List<SvgNode>();
  SvgGroup(Group shell): super(shell) {}

  SVG.SvgElement _createElement() {
    return new SVG.GElement();
  }

  void addChild(SvgNode child) {
    _children.add(child);
    child.parent = this;
    this._element.append(child._element);

    if (!shell.isReflection) {
      _addDefs(child);
    }
  }

  void _addDefs(SvgNode child) {
    if (layer != null) {
      child._defs.forEach((def) {
        SvgNode defImpl = def.createImpl(svg);
        (layer as SvgLayer).addDef(def, defImpl);
      });
    }
  }

  void removeChild(SvgNode node) {
    node.remove();
  }

  void clearChildren() {
    while(_children.isNotEmpty){
      removeChild(_children.first);
    }
    _children.forEach((child) => child.remove());
  }

  void insertChild(int index, SvgNode node) {
    node.parent = this;
    _children.insert(index, node);
    this._element.nodes.insert(index, node._element);
    _addDefs(node);
  }

  void _setElementAttribute(String attr) {
    super._setElementAttribute(attr);
    num x = attrs[X];
    num y = attrs[Y];
    bool b = false;
    if (x != null) {
      shell.translateX = x;
      b = true;
    }

    if (y != null) {
      shell.translateY = y;
      b = true;
    }

    if (b) {
      translate();
    }
  }

  List get _defs {
    List defs = [];
    if (fill is SCPattern ||
        fill is Gradient) {
        defs.add(fill);
    }

    if (stroke is SCPattern) {
      defs.add(stroke);
    }

    _children.forEach((child) {
      defs.addAll(child._defs);
    });
    return defs;
  }

  List<SvgNode> get children => _children;

  String get _nodeName => SC_GROUP;
}