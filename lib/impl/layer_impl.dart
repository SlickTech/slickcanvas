part of smartcanvas;

abstract class LayerImpl extends NodeImpl {
  dynamic _element;

  LayerImpl(Layer shell): super(shell);

  void suspend();

  void resume();

  dynamic get element => _element;

  @override
  LayerImpl get layer => this;
}
