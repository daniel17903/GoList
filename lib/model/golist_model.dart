import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class GoListModel {
  late final String id;
  late final int modified;
  late final bool deleted;

  GoListModel({String? id, int? modified, bool? deleted}) {
    this.id = id ?? const Uuid().v4();
    this.modified = modified ?? DateTime.now().millisecondsSinceEpoch;
    this.deleted = deleted ?? false;
  }

  Map<String, dynamic> toJson();

  bool isEqualTo(GoListModel other) {
    return const DeepCollectionEquality().equals(toJson(), other.toJson());
  }

}
