part of smartcanvas;

String capitalize(String s) {
  if (s != null && s.length > 0) {
    if (s.length == 1) {
      return s[0].toUpperCase();
    }
    return s[0].toUpperCase() + s.substring(1);
  }
  return s;
}

dynamic getValue(Map map, key, [defaultValue = null]) {
  if (map == null) {
    return defaultValue;
  }

  var rt = map[key];
  return rt == null ? defaultValue : rt;
}

void setValue(Map map, key, value) {
  map[key] = value;
}


dynamic clone(dynamic source) {
  var rt;
  if (source is Map) {
    rt = {};
    source.forEach((k, v) {
      rt[k] = clone(v);
    });
  } else if (source is Iterable) {
    if (source is List) {
      rt = [];
    } else if (source is Set) {
      rt = new Set();
    }

    if (rt != null) {
      source.forEach((item) {
        rt.add(clone(item));
      });
    } else {
      rt = new Iterable.generate(source.length, (item) {
        return clone(item);
      });
    }
  } else {
    rt = source;
  }
  return rt;
}

Map merge(Map map1, Map map2, [Map map3 = null, Map map4 = null]) {
  Map rt = map1 == null ? {} : clone(map1);

  void _mergeIterable(mergeTo, Iterable itr) {
    int i = 0;
    for (; i < mergeTo.length && i < itr.length; i++) {
      var item = itr.elementAt(i);
      if (item is Map) {
        var targetItem = mergeTo.elementAt(i);
        targetItem = merge(mergeTo.elementAt(i), item);
      } else if (item is Iterable) {
        _mergeIterable(mergeTo, item);
      } else {
        mergeTo = itr;
      }
    }

    for (; i < itr.length; i++) {
      mergeTo.add(clone(itr.elementAt(i)));
    }

  }

  void _merge(Map map) {
    map.forEach((k, v) {
      if (rt.containsKey(k)) {
        if (v is Map) {
          rt[k] = merge(rt[k], map[k]);
        } else if (v is Iterable){
          _mergeIterable(rt[k], v);
        } else {
          rt[k] = v;
        }
      } else {
        rt [k] = clone(v);
      }
    });
  }

  if (map2 != null) {
    _merge(map2);
  }

  if (map3 != null) {
    _merge(map3);
  }
  if (map4 != null) {
    _merge(map4);
  }
  return rt;
}