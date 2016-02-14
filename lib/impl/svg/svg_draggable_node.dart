part of smartcanvas.svg;

class SvgDraggable {

  svg.SvgElement _element;
  Node _node;

  StreamSubscription _dragHandler;
  StreamSubscription _dragMoveHandler;
  StreamSubscription _dragEndHandler;

  bool _dragStarting = false;
  bool _dragStarted = false;

  bool _dragging = false;

  Position _preDragPointerPosition;

  final bool _isMobile = isMobile();

  void initDraggable(Node node, svg.SvgElement el) {
    this._node = node;
    this._element = el;
  }

  void enableDragging() {
    _dragHandler = _element.onMouseDown.listen(_dragStart);
  }

  void disableDragging() {
    _dragHandler.cancel();
    _dragHandler = null;
    _dragEnd();
  }

  void _dragStart(dom.MouseEvent e) {
    if (e.button != 0 ||
        (dom.window.navigator.userAgent.contains('Mac OS') &&
        e.ctrlKey) || // simulated right click on Mac
        _node.stage.isDragging || _dragStarting) {
      return;
    }

//    e.preventDefault();
//    e.stopPropagation();
    _dragStarting = true;

    if (_dragMoveHandler == null) {
      if (_isMobile) {
        _dragMoveHandler = _node.stage.element.onTouchMove.listen(_touchDragMove);
      } else {
        _dragMoveHandler = _node.stage.element.onMouseMove.listen(_mouseDragMove);
      }
    }
    _dragMoveHandler.resume();

    if (_dragEndHandler == null) {
      if (_isMobile) {
        _dragEndHandler = _node.stage.element.onTouchEnd.listen(_touchDragEnd);
      } else {
        _dragEndHandler = _node.stage.element.onMouseUp.listen(_mouseDragEnd);
      }
    }
    _dragEndHandler.resume();

    _calculateDragOffset();
  }

  void _calculateDragOffset() {
    _preDragPointerPosition = _node.stage.pointerPosition;
  }

  void _mouseDragMove(dom.MouseEvent e) => _dragMove(e);
  void _touchDragMove(dom.TouchEvent e) => _dragMove(e);

  void _dragMove(e) {
    if (_dragStarting) {
      e.preventDefault();
      e.stopPropagation();

      if (!_dragStarted) {
        _dragging = true;
        _node.fire(dragStart, e);
        _dragStarted = true;
      }

      var pointerPosition = _node.stage.pointerPosition;
      var diffX = pointerPosition.x - _preDragPointerPosition.x;
      var diffY = pointerPosition.y - _preDragPointerPosition.y;

      _preDragPointerPosition = pointerPosition;

      if (handleDragMove(e, diffX, diffY)) {
        _node.fire(dragMove, e);
      }
    }
  }

  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {
    _node.translate(_node.translateX + diffX, _node.translateY + diffY);
    return true;
  }

  void _touchDragEnd(dom.TouchEvent e) => _dragEnd(e);
  void _mouseDragEnd(dom.MouseEvent e) => _dragEnd(e);

  void _dragEnd([e]) {
    if (e != null) {
      e.preventDefault();
      e.stopPropagation();
    }

    _dragStarting = false;
    _dragging = false;

    if (_dragStarted) {
      _node.fire(dragEnd, e);
    }
    _dragStarted = false;

    if (_dragMoveHandler != null) {
      _dragMoveHandler.cancel();
      _dragMoveHandler = null;
    }

    if (_dragEndHandler != null) {
      _dragEndHandler.cancel();
      _dragEndHandler = null;
    }
  }

}

