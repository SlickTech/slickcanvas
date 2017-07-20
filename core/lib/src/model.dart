import 'package:observable/observable.dart';
export 'package:observable/observable.dart';

import 'package:uuid/uuid.dart';
export 'package:uuid/uuid.dart';

import 'package:dart_ext/collection_ext.dart' as ext;

class Model {
  final _properties = new ObservableMap<String, dynamic>();

  get properties => _properties;

  static var _uuid = new Uuid();

  Map<String, dynamic> cloneProperties(
      [Map<String, dynamic> propertiesOverride]) {
    var propClone = ext.clone(properties);
    if (propertiesOverride != null) {
      var mapDiffer = new MapDiffer<String, dynamic>();
      var diffs = mapDiffer.diff(propClone, propertiesOverride);
      for (var record in diffs) {
        if (!record.isRemove) {
          propClone[record.key] = record.newValue;
        }
      }
    }
    return propClone;
  }

  dynamic getProperty(String propName, [dynamic defaultValue = null]) {
    if (properties.containsKey(propName)) {
      return properties[propName];
    }
    return defaultValue;
  }

  void setProperty(String propName, dynamic value, {bool removeIfNull: true}) {
    if (value == null && removeIfNull) {
      removeProperty(propName);
    } else {
      properties[propName] = value;
    }
  }

  void removeProperty(String propName) => properties.remove(propName);

  bool hasProperty(String propName) => properties.containsKey(propName);

  void set id(String value) => setProperty('id', value);
  String get id => getProperty('id');

  void addClass(String value) {
    if (!properties.containsKey('classNames')) {
      properties['classNames'] = <String>[];
    }
    properties['classNames'].add(value);
  }

  bool hasClass(String value) {
    if (properties['classNames'] != null) {
      return properties['classNames'].contains(value);
    }
    return false;
  }

  List<String> get classNames => getProperty('classNames', []);

  void set guid(String value) => setProperty('guid', value);
  String get guid {
    if (!hasProperty('guid')) {
      setProperty('guid', _uuid.v4());
    }
    return properties['guid'];
  }
}
