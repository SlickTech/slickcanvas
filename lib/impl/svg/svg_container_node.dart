part of smartcanvas.svg;

abstract class SvgContainerNode extends SvgNode with Container<SvgNode> {

  SvgContainerNode(ContainerNode shell, bool isReflection): super(shell, isReflection);

  @override
  void addChild(SvgNode child) {
    children.add(child);
    child.parent = this;
    this._implElement.append(child.element);

    if (stage != null && !_isReflection) {
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

  @override
  void removeChild(SvgNode node) => node.remove();

  @override
  void clearChildren() {
    while (children.isNotEmpty) {
      removeChild(children.first);
    }
  }

  @override
  void insertChild(int index, SvgNode node) {
    node.parent = this;
    children.insert(index, node);
    this._implElement.nodes.insert(index, node.element);
    _addDefs(node);
  }

  @override
  List get _defs {
    var defs = super._defs;

    children.forEach((child) {
      defs.addAll(child._defs);
    });
    return defs;
  }
}
