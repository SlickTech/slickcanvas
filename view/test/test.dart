@TestOn("browser")

import 'package:test/test.dart';
import 'dart:html' as dom;
import 'package:slickcanvas_view/view.dart';

Stage stage;

void main() {

  dom.Element container = dom.document.querySelector('#canvas');
  stage = new Stage(container);
}
