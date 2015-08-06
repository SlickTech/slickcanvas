##0.2.0+2
* Fixed an issue where invisible node still shows on canvas.
* Add VISIBLE configuration to allow node configured to invisible.
* Fixed an issue where if base tag presents, set fill gradient second time does not take any effect.

##0.2.0+1
* Fixed reflectChild out of range exception

##0.2.0
* Fixed errors complained by dev-compiler.
* Changed styles according to dart style guid.
* Fixed path drawing for canvas
* Added AnimLoopStatu enum
* BREAKING CHANGE - renamed event const strings from MOUSEUP, MOUSEDOWN, MOUSEMOVE, MOUSELEAVE, MOUSEOVER, MOUSEOUT,
CLICK, DBLCLICK, DRAGSTART, DRAGEND, DRAGMOVE, CHANGED, ATTR_CHANGED to mouseUp, mouseDown, mouseMove, mouseLeave, 
mouseOver, mouseOut, click, delClick, dragStart, dragEnd, dragMove, changed, attrChanged.
* BREAKING CHANGE - added CanvasType enum, Layer type should be specified by CanvasType instead.


##0.1.9
* Fixed an issue where node jump to different location during drag move if stage panned or zoomed.
* Fixed an issue where node dragging stopped working after panning stage.
* Breaking change - [according to dart style duide](https://www.dartlang.org/articles/style-guide/##avoid-returning-this-from-methods-just-to-enable-a-fluent-interface), event bus .on and .off nolonger return this.

##0.1.8
* Fixed an issue where FuncIRI for fill does not work if html file has a base tag.
* Implement rotate.
* Implement svg/canvas image.
* Implement text warpping.
* Simplified reflection logic.

##0.1.7
* Renamed stage's DISALBE_SHADOW_ROOT to CREATE_SHADOW_ROOT and set the default to false becasuse createShadowRoot only works on chrome.
* Fixed an issue where _setTransform caused an exeption in Safari.

##0.1.6
* updated dart-ext lib to 0.0.8
* updated examples
###### Bug fix:
* Fixed an issue where cloning a node didn't clone its transform matrix.
* Fixed node scale didn't work.
* Fixed reflection didn't maintain correct layering.
* Fixed LineJoin and LineCap for Path
###### New figure:
* Added font-style support to Text
* Implemented static stage

##0.1.5
* When calculate absolutePositon, do not count layer's position
* Fixed drage move flickering issue; 
* Fixed typo;

##0.1.4
* Fix missmatch between stage.children and stage.element.nodes
* Implement svg layer suspend/resume
* Stage pointer position take translate into account
* Add free drawing example

##0.1.3
* If path isn't in a stage yet, use its config to calculate BBox.

##0.1.2
* Fixed pointer position update on stage scale

##0.1.1
* Fixed typo
* Add background to layer.
* [Canvas] Fixed an issue where when dragging a shape, other shapes around the dirty ragin were cut off. [##8](https://github.com/kzhdev/dart-smart-canvas/issues/8)
* [SVG] Fixed an issue where when d changed, path didn't update.
* Update pointer poistion when stage scale changed.

##0.1.0
* Implemente basic canvas shapes
* Fixed an issue where svg defs layer throw null exception when changing fill to gradient.
* Breaking Change - changed 'XXchanged' event handler signature from (oldValue, newValue) to (newValue, oldValue).

##v0.0.31
* Fixed an strage issue in FireFox where fill pattern/gradient is not always applied.

##v0.0.30
* Fix an issue where set SvgSvgElement.viewBox.baseVal directly caused an null exception in FireFox
* Fix text font-size in FireFox
* Fix fill-opacity didn't apply to svg node. (Thanks zolzounet)

##v0.0.29
* Fix an issue where set draggable to false has no effect inside mousedown event handler. 
* Make sure a def node only added to DOM once.
### Some performance implrovements:
* rester DOM events only on reflectoon nodes
* don't add pattern and gradiant in reflecton nodes.

##v0.0.28
* Fix circle and ellipse BBox
* Fix typo

##v0.0.27
* Fixed stage dragging

##v0.0.26
* Removed transformMatrix from NodeImpl.
* Dragging is apply to Node directly.
* Fixed an issue where a draggable group can't be dragged if all its children were not reflectable.
* Fixed stage style.
* Fixed an issue where move block from one layer to another then move it back caused a def being added multiple times.

### Breaking changes
* Rename TransformMatrix properties' name;
* Rename Stage tx/ty to translateX/translateY;

##v0.0.25
###Bugs
* Fix gradient/pattern def beging added multiple times
* Gradient doesn't work if id didn't present in configuration
* Moved X1, Y1, X2, Y2 attribute to linear griadent. Added CX, CY, R, FX, FY attributes to radial gradient. Added spreadModel for both.

##v0.0.24
* Fix stage pointer position

##v0.0.23
* Fire dragend event
* Unsubscribe stage events when layer removed

##v0.0.22
###Bugs
* Fix an issue where gradient doesn't apply when changed from a fill color.

###Breaking change
* changed Container interface functions from add, removeChild, insert to addChild, removeChild, insertChild
* added clearChildren interface in Container.

##v0.0.21

* Added font-weight property in text.

##v0.0.20

* Expose reflection classes
* Dynamically adjust canvas tile size

###Bugs
* When layer width changed the viewbox size needs to consider stage scale

##v0.0.19

###Bugs
* When adding svg layer to stage, set the viewbox correctly.

##v0.0.18

###Bugs
* Fixed an issue where stage stuck in dragging mode on second time of dragging the stage.

##v0.0.17

###Bugs
* Fixed an bug where set stage.draggable to false while dragging the stage caused it stuck in dragging mode.

##v0.0.16

###Bugs
* Fixed issue [##5](https://github.com/kzhdev/dart-smart-canvas/issues/5) - A reflectable node might be reflected when adding the node to a group which was on a unstaged layer

###Features
* Implemented cavas tile

##v0.0.15

###Bugs
* Group removeChild should remove child impl as well.

##v0.0.14

###Bugs
* Fixed dragging stopped working
* Pattern didn't apply after node added into a canvas
* Pattern didn't apply if pattern didn't have id attribute
* When node removed, pattern/gradient didn't remvoed from DOM svg element

##v0.0.13

###Features
* SVG gradient support
* Moved def to svg implementation
* def won't be created for reflection
* Alway return text with from textMearue
