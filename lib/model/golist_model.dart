import 'package:collection/collection.dart';
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
}
