import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_list/model/mergeable.dart';
import 'package:uuid/uuid.dart';

abstract class GoListModel {
  late String id;
  late DateTime modified;
  late bool deleted;
  late String name;

  GoListModel(
      {required this.name, String? id, DateTime? modified, bool? deleted}) {
    this.id = id ?? const Uuid().v4();
    this.modified = modified ?? DateTime.now();
    this.deleted = deleted ?? false;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'deleted': deleted,
        'modified': modified.toIso8601String(),
        'name': name
      };

  bool isEqualTo(GoListModel other) {
    return const DeepCollectionEquality().equals(toJson(), other.toJson());
  }

  T lastModified<T extends GoListModel>(T a, T b) {
    if (a.modified.isAfter(b.modified)) {
      return a;
    }
    return b;
  }
}
