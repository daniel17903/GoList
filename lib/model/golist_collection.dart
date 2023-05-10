import 'package:collection/collection.dart';
import 'package:go_list/model/mergeable.dart';

import 'golist_model.dart';

class GoListCollection<T extends GoListModel>
    implements MergeAble<GoListCollection<T>> {
  final List<T> _entries;
  final List<T> _deletedEntries;
  List<String> _order = [];

  GoListCollection([List<T>? entries, List<T>? deletedEntries])
      : _entries = entries ?? [],
        _deletedEntries = deletedEntries ?? [];

  bool Function(T) _idEquals(String id) {
    return (e) => e.id == id;
  }

  GoListCollection<T> copyWith(List<T> entries, [List<T>? deletedEntries]) {
    return GoListCollection<T>(entries, deletedEntries ?? _deletedEntries);
  }

  void cleanUp() {
    DateTime tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    _entries.removeWhere(
        (e) => e.deleted == true && e.modified.isBefore(tenDaysAgo));
  }

  GoListCollection<T> sort([int Function(T, T)? compare]) {
    _entries.sort(compare);
    return this;
  }

  GoListCollection<T> skip(int n) {
    return copyWith(_entries.skip(n).toList());
  }

  int length() {
    return _entries.length;
  }

  T get(int index) {
    return _entries[index];
  }

  GoListCollection<T> sortByIds([List<String>? ids]) {
    List<String> sortedIds = ids ?? _order;
    _entries.sort(
        (a, b) => sortedIds.indexOf(a.id).compareTo(sortedIds.indexOf(b.id)));
    return this;
  }

  GoListCollection<T> mapEntries(T Function(T) f) {
    return copyWith(_entries.map(f).toList());
  }

  T? first() {
    return _entries.first;
  }

  Iterable map(Function(T) f) {
    return _entries.map(f);
  }

  GoListCollection<T> whereEntry(bool Function(T) test) {
    return copyWith(_entries.where(test).toList());
  }

  List<Map<String, dynamic>> toJson() {
    return _entries.map((e) => e.toJson()).toList();
  }

  bool containsEntryWithId(String id) {
    return _entries.any(_idEquals(id));
  }

  T removeEntryWithId(String id) {
    return _entries.removeAt(_entries.indexWhere(_idEquals(id)));
  }

  T? entryWithId(String id) {
    return _entries.firstWhereOrNull(_idEquals(id)) ??
        _deletedEntries.firstWhereOrNull(_idEquals(id));
  }

  T removeAt(int index) {
    return _entries.removeAt(index);
  }

  void setOrder(List<String> order) {
    _order = order;
    sortByIds();
  }

  bool isNotEmpty() {
    return _entries.isNotEmpty;
  }

  List<T> entries() {
    return _entries;
  }

  GoListCollection<T> upsert(T entry, [int? index]) {
    _entries.removeWhere(_idEquals(entry.id));
    _deletedEntries.removeWhere(_idEquals(entry.id));
    if (entry.deleted) {
      _deletedEntries.add(entry);
    } else {
      _entries.insert(index ?? _entries.length, entry);
      if (index == null) {
        sortByIds();
      }
    }
    return this;
  }

  Set<String> ids() {
    return {
      ..._entries.map((e) => e.id).toSet(),
      ..._deletedEntries.map((e) => e.id).toSet()
    };
  }

  GoListCollection<T> copy() {
    return GoListCollection([..._entries], [..._deletedEntries]);
  }

  searchBy(String? searchText) {
    _entries.sort((entry1, entry2) {
      startsWithIgnoreCase(String value, String start) {
        return value.toLowerCase().startsWith(start.toLowerCase());
      }

      if (searchText != null && searchText.isNotEmpty) {
        if (startsWithIgnoreCase(entry2.name, searchText)) {
          return 1;
        } else if (startsWithIgnoreCase(entry1.name, searchText)) {
          return -1;
        }
        return 0;
      } else {
        return entry2.modified.compareTo(entry1.modified);
      }
    });
    return this;
  }

  @override
  GoListCollection<T> merge(GoListCollection<T> other) {
    Set<String> elementIds = ids().union(other.ids());

    for (String elementId in elementIds) {
      T? elementWithId = entryWithId(elementId);
      T? otherElementWithId = other.entryWithId(elementId);

      if (elementWithId != null && otherElementWithId != null) {
        upsert((elementWithId as MergeAble).merge(otherElementWithId));
      } else if (elementWithId != null) {
        upsert(elementWithId);
      } else if (otherElementWithId != null) {
        upsert(otherElementWithId);
      }
    }
    return this;
  }
}
