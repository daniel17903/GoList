import 'package:collection/collection.dart';
import 'package:go_list/model/golist_model.dart';
import 'package:go_list/model/shopping_list.dart';

class Diff<T extends GoListModel, S extends GoListModel> {
  List<T> elementsToUpdateIn1 = [];
  List<T> elementsToUpdateIn2 = [];
  Map<String, Diff<S, void>> subElementDiffs = {};

  Diff(
      {this.elementsToUpdateIn1 = const [],
      this.elementsToUpdateIn2 = const []});

  T? _elementById(List<T> elements, String id) {
    return elements.firstWhereOrNull((sl) => sl.id == id);
  }

  Diff.diff(List<T> elementsFromSp1, List<T> elementsFromSp2) {
    Set<String> elementIds =
        [...elementsFromSp1, ...elementsFromSp2].map((sl) => sl.id).toSet();

    for (String elementId in elementIds) {
      T? elementFromSp1 = _elementById(elementsFromSp1, elementId);
      T? elementFromSp2 = _elementById(elementsFromSp2, elementId);

      if (elementFromSp1 == null) {
        if (!elementFromSp2!.deleted) elementsToUpdateIn1.add(elementFromSp2);
      } else if (elementFromSp2 == null) {
        if (!elementFromSp1.deleted) elementsToUpdateIn2.add(elementFromSp1);
      } else if (!elementFromSp1.isEqualTo(elementFromSp2)) {
        if (elementFromSp1.modified > elementFromSp2.modified) {
          elementsToUpdateIn2.add(elementFromSp1);
        } else {
          elementsToUpdateIn1.add(elementFromSp2);
        }
      }

      if (elementFromSp1 is ShoppingList && elementFromSp2 is ShoppingList) {
        subElementDiffs[elementId] = Diff<S, GoListModel>.diff(
            elementFromSp1.items as List<S>, elementFromSp2.items as List<S>);
      }
    }
  }

  bool isEmpty() =>
      elementsToUpdateIn1.isEmpty &&
      elementsToUpdateIn2.isEmpty &&
      subElementDiffs.isEmpty;
}
