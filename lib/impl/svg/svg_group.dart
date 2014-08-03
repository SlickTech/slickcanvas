part of smartcanvas.svg;

class SvgGroup extends SvgNode implements Container<SvgNode> {
  List<SvgNode> _children = new List<SvgNode>();
  SvgGroup(Group shell, bool isReflection): super(shell, isReflection) {}

  SVG.SvgElement _createElement() {
    return new SVG.GElement();
  }

  void addChild(SvgNode child) {
    _children.add(child);
    child.parent = this;
    this._element.append(child._element);

    if (stage != null && !shell.isReflection) {
      _addDefs(child);
    }
  }

  void _addDefs(SvgNode child) {
    if (stage != null) {
      child._defs.forEach((def) {
        SvgDefLayer.impl(this.stage).addDef(def);
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