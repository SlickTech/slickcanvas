#v0.0.21

* Added font-weight property in text.

#v0.0.20

* Expose reflection classes
* Dynamically adjust canvas tile size

###Bugs
* When layer width changed the viewbox size needs to consider stage scale

#v0.0.19

###Bugs
* When adding svg layer to stage, set the viewbox correctly.

#v0.0.18

###Bugs
* Fixed an issue where stage stuck in dragging mode on second time of dragging the stage.

#v0.0.17

###Bugs
* Fixed an bug where set stage.draggable to false while dragging the stage caused it stuck in dragging mode.

#v0.0.16

###Bugs
* Fixed issue [#5](https://github.com/kzhdev/dart-smart-canvas/issues/5) - A reflectable node might be reflected when adding the node to a group which was on a unstaged layer

###Features
* Implemented cavas tile

#v0.0.15

###Bugs
* Group removeChild should remove child impl as well.

#v0.0.14

###Bugs
* Fixed dragging stopped working
* Pattern didn't apply after node added into a canvas
* Pattern didn't apply if pattern didn't have id attribute
* When node removed, pattern/gradient didn't remvoed from DOM svg element

#v0.0.13

###Features
* SVG gradient support
* Moved def to svg implementation
* def won't be created for reflection
* Alway return text with from textMearue