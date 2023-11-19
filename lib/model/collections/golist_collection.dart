import 'package:collection/collection.dart';

import '../golist_model.dart';

abstract class GoListCollection<T extends GoListModel> {
  final List<T> _entries;

  GoListCollection(this._entries);

  List<T> mergeLists(List<T> a, List<T> b) {
    Set<String> ids =
        a.map((e) => e.id).toSet().union(b.map((e) => e.id).toSet());

    return ids.map((id) {
      T? entryA = a.where((e) => e.id == id).firstOrNull;
      T? entryB = b.where((e) => e.id == id).firstOrNull;

      if (entryA != null && entryB != null) {
        return entryA.merge(entryB) as T;
      }
      return (entryA ?? entryB)!;
    }).toList();
  }

  void removeWhere(bool Function(T) shouldBeRemoved) {
    entries.removeWhere(shouldBeRemoved);
  }

  void sort([int Function(T, T)? compare]) {
    _entries.sort(compare);
  }

  bool equals(GoListCollection<T> other) {
    return this.length == other.length &&
        entries.every((entry) {
          var otherEntry = other.entryWithId(entry.id);
          return otherEntry != null && otherEntry.equals(entry);
        });
  }

  int get length => _entries.length;

  T get(int index) {
    return _entries[index];
  }

  T? first() {
    return _entries.firstOrNull;
  }

  Iterable<E> map<E>(E Function(T t) toElement) {
    return _entries.map(toElement);
  }

  List<Map<String, dynamic>> toJson() {
    return _entries.map((e) => e.toJson()).toList();
  }

  bool containsEntryWithId(String id) {
    return _entries.any(GoListModel.equalsById(id));
  }

  void removeEntryWithId(String id) {
    int indexToRemove = _entries.indexWhere(GoListModel.equalsById(id));
    if (indexToRemove != -1) {
      removeAt(indexToRemove);
    }
  }

  T? entryWithId(String id) {
    return _entries.firstWhereOrNull(GoListModel.equalsById(id));
  }

  T removeAt(int index) {
    return _entries.removeAt(index);
  }

  bool isNotEmpty() {
    return _entries.isNotEmpty;
  }

  List<T> get entries => _entries;

  void upsert(T entry) {
    removeWhere(GoListModel.equalsById(entry.id));
    _entries.add(entry);
  }
}
