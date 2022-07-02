import 'package:go_list/model/golist_model.dart';
import 'package:collection/collection.dart';

class ListOf<T extends GoListModel> extends DelegatingList<T> {
  final List<T> _l;

  ListOf(List<T> l)
      : _l = l,
        super(l);

  ListOf<T> copy() {
    return ListOf<T>([..._l]);
  }

  ListOf<T> mapEntries(T Function(T) f) {
    return ListOf<T>(_l.map(f).toList());
  }

  ListOf<T> whereEntry(bool Function(T) test) {
    return ListOf<T>(_l.where(test).toList());
  }

  List<Map<String, dynamic>> toJson() {
    return _l.map((e) => e.toJson()).toList();
  }

  ListOf<T> updateEntry(T entry, {transform}) {
    return updateWith(ListOf<T>([entry]), transform: transform);
  }

  ListOf<T> updateWith(ListOf<T> otherList, {transform}) {
    otherList = otherList.copy();

    T removeAndTransform(T entry) {
      T entryFromOtherList =
          otherList.removeAt(otherList.indexWhere((e) => e.id == entry.id));
      if (transform != null) {
        return transform(entry);
      }
      return entryFromOtherList;
    }

    return ListOf<T>([
      for (final entry in _l)
        if (otherList.any((e) => e.id == entry.id))
          removeAndTransform(entry)
        else
          entry,

      // entries that were not in the list before
      ...otherList
    ]);
  }
}
