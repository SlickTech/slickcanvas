part of smartcanvas;

ClientDetectDevice _cd = new ClientDetectDevice();

bool isMobile() => _cd.isMobile();

bool isTablet() => _cd.isTablet();

bool isDesktop() => _cd.isDesktop();

bool isDomEvent(String event) {
  switch (event) {
    case mouseDown:
    case mouseUp:
    case mouseEnter:
    case mouseLeave:
    case mouseOver:
    case mouseOut:
    case click:
    case dblClick:
      return true;
    default:
      return false;
  }
}
