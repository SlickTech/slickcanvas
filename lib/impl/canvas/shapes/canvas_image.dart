part of smartcanvas.canvas;

class CanvasImage extends CanvasGraphNode {
  DOM.ImageElement _image;
  bool _imageReady = false;
  List<Function> _pendingDrawings = [];

  CanvasImage(Image shell): super(shell) {
    _image = new DOM.ImageElement(src: shell.href);
    _image.onLoad.listen((e) {
      _imageReady = true;
      if (_pendingDrawings.isNotEmpty) {
         _pendingDrawings.forEach((func) {
           func();
         });
         _pendingDrawings.clear();
      }
    });
  }

  void _cacheGraph() {}

  void __drawGraph(DOM.CanvasRenderingContext2D context) {
    if (_imageReady)
    {
      context.drawImage(_image, 0, 0);
//      context.drawImage(_image, _image.clientWidth, _image.clientHeight);
//      context.drawImageScaled(_image, 0, 0, _image.clientWidth / DOM.window.devicePixelRatio,
//          _image.clientHeight / DOM.window.devicePixelRatio);
    } else {
      _pendingDrawings.add(() {
        context.drawImage(_image, 0, 0);
//        context.drawImage(_image, _image.clientWidth, _image.clientHeight);
//        context.drawImageScaled(_image, 0, 0, _image.clientWidth / DOM.window.devicePixelRatio,
//          _image.clientHeight / DOM.window.devicePixelRatio);
      });
    }
  }

  Image get shell => super.shell;
}