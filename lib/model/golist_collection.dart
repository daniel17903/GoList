import 'package:collection/collection.dart';

import 'golist_model.dart';

class GoListCollection<T extends GoListModel> {
  final List<T> _entries;

  GoListCollection([List<T>? entries]) : _entries = entries ?? [];

  void cleanUp() {
    DateTime tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    _entries.removeWhere(
        (e) => e.deleted == true && e.modified.isBefore(tenDaysAgo));
  }

  void sort([int Function(T, T)? compare]) {
    _entries.sort(compare);
  }

  int length() {
    return _entries.length;
  }

  T get(int index) {
    return _entries[index];
  }

  T? first() {
    return _entries.first;
  }

  Iterable map(Function(T) f) {
    return _entries.map(f);
  }

  List<Map<String, dynamic>> toJson() {
    return _entries.map((e) => e.toJson()).toList();
  }

  bool containsEntryWithId(String id) {
    return _entries.any(GoListModel.equalsById(id));
  }

  T removeEntryWithId(String id) {
    return _entries.removeAt(_entries.indexWhere(GoListModel.equalsById(id)));
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
    _entries.removeWhere(GoListModel.equalsById(entry.id));
    _entries.add(entry);
  }

}
