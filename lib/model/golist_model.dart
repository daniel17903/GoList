import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

abstract class GoListModel {
  late String id;
  late DateTime modified;
  late bool _deleted;
  late String _name;

  GoListModel(
      {required String name, String? id, DateTime? modified, bool? deleted}) {
    this.id = id ?? const Uuid().v4();
    this.modified = modified ?? DateTime.now();
    _name = name;
    _deleted = deleted ?? false;
  }

  GoListModel.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'deleted': deleted,
        'modified': modified.toIso8601String(),
        'name': name
      };

  T lastModified<T extends GoListModel>(T a, T b) {
    if (a.modified.isAfter(b.modified)) {
      return a;
    }
    return b;
  }

  bool modifiedAtLeastNDaysBefore(int days) =>
      modified.isBefore(DateTime.now().subtract(Duration(days: days)));

  @override
  bool operator ==(Object other) =>
      other is GoListModel &&
      const DeepCollectionEquality().equals(toJson(), other.toJson());

  @override
  int get hashCode => toJson().hashCode;

  static int compareByModified(GoListModel a, GoListModel b) {
    return b.modified.compareTo(a.modified);
  }

  static bool Function(GoListModel) equalsById(String id) {
    return (e) => e.id == id;
  }

  static bool Function(GoListModel) equalsByName(GoListModel other) {
    return (e) =>
        e.name.trim().toLowerCase() == other.name.trim().toLowerCase();
  }

  bool equals(GoListModel other) {
    return mapEquals(toJson(), other.toJson());
  }

  bool get deleted => _deleted;

  set deleted(bool deleted) {
    modified = DateTime.now();
    _deleted = deleted;
  }

  String get name => _name;

  set name(String name) {
    modified = DateTime.now();
    _name = name;
  }

  GoListModel merge(GoListModel other);
}
