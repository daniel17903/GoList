import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/mergeable.dart';
import 'package:collection/collection.dart';

import 'golist_model.dart';

class ExtendedGoListCollection<T extends GoListModel>
    extends GoListCollection<T>
    implements MergeAble<ExtendedGoListCollection<T>> {
  late final List<T> _deletedEntries;

  ExtendedGoListCollection({List<T>? entries, List<T>? deletedEntries})
      : super(entries) {
    _deletedEntries = deletedEntries ?? [];
  }

  GoListCollection<T> copyWith(List<T> entries, [List<T>? deletedEntries]) {
    return ExtendedGoListCollection<T>(
        entries: entries, deletedEntries: deletedEntries ?? _deletedEntries);
  }

  @override
  ExtendedGoListCollection<T> upsert(T entry) {
    entries.removeWhere(GoListModel.equalsById(entry.id));
    _deletedEntries.removeWhere(GoListModel.equalsById(entry.id));
    if (entry.deleted) {
      _deletedEntries.add(entry);
    } else {
      entries.add(entry);
    }
    sort();
    return this;
  }

  @override
  T? entryWithId(String id) {
    return super.entryWithId(id) ??
        _deletedEntries.firstWhereOrNull(GoListModel.equalsById(id));
  }

  Set<String> ids() {
    return {
      ...entries.map((e) => e.id).toSet(),
      ..._deletedEntries.map((e) => e.id).toSet()
    };
  }

  @override
  ExtendedGoListCollection<T> merge(ExtendedGoListCollection<T> other) {
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
