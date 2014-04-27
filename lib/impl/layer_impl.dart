part of smartcanvas;

abstract class LayerImpl extends NodeImpl implements Container<NodeImpl> {

  DOM.Element _element;
  LayerImpl(Layer shell): super(shell) {}

  void suspend();
  void resume();

  DOM.Element get element => _element;
}