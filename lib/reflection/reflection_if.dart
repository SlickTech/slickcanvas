part of smartcanvas;

abstract class I_Reflection {
  Node _node;
}

abstract class I_Container_Reflection extends I_Reflection {
  void insertNode(I_Reflection node);
  void reflectionAdd(Node node);
}

I_Reflection _createReflection(Node node) {
  if (node._reflection != null) {
    return node._reflection;
  }
  return (node is Group ? new ReflectionGroup(node): new ReflectionNode(node)) as I_Reflection;
}