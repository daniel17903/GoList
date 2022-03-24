import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class GoListModel extends ChangeNotifier {
  late String id;
  late int modified;
  late bool _deleted;

  GoListModel({String? id, int? modified, bool? deleted}) {
    this.id = id ?? const Uuid().v4();
    this.modified = modified ?? DateTime.now().millisecondsSinceEpoch;
    _deleted = deleted ?? false;
  }

  set deleted(bool deleted) {
    _deleted = deleted;
    notifyListeners();
  }

  bool get deleted => _deleted;

  Map<String, dynamic> toJson();

  bool isEqualTo(GoListModel other) {
    return const DeepCollectionEquality().equals(toJson(), other.toJson());
  }
}
