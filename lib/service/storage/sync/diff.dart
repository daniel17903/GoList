import 'package:collection/collection.dart';
import 'package:go_list/model/golist_model.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';

class Diff<T extends GoListModel, S extends GoListModel> {
  List<T> elementsToUpdateInLocalStorage = [];
  List<T> elementsToUpdateInRemoteStorage = [];
  Map<String, Diff<S, void>> subElementDiffs = {};

  Diff(
      {this.elementsToUpdateInLocalStorage = const [],
      this.elementsToUpdateInRemoteStorage = const []});

  T? _elementById(List<T> elements, String id) {
    return elements.firstWhereOrNull((sl) => sl.id == id);
  }

  Diff.diff(List<T> elementsFromSp1, List<T> elementsFromSp2) {
    Set<String> elementIds =
        [...elementsFromSp1, ...elementsFromSp2].map((sl) => sl.id).toSet();

    for (String elementId in elementIds) {
      T? elementFromSp1 = _elementById(elementsFromSp1, elementId);
      T? elementFromSp2 = _elementById(elementsFromSp2, elementId);

      // deleted items have to be synced in order to share deletion
      if (elementFromSp1 == null) {
        if (!elementFromSp2!.deleted || elementsFromSp2 is Item) {
          elementsToUpdateInLocalStorage.add(elementFromSp2);
        }
      } else if (elementFromSp2 == null) {
        if (!elementFromSp1.deleted || elementsFromSp1 is Item) {
          elementsToUpdateInRemoteStorage.add(elementFromSp1);
        }
      } else if (!elementFromSp1.isEqualTo(elementFromSp2)) {
        if (elementFromSp1.modified > elementFromSp2.modified) {
          elementsToUpdateInRemoteStorage.add(elementFromSp1);
        } else {
          elementsToUpdateInLocalStorage.add(elementFromSp2);
        }
      }

      if (elementFromSp1 is ShoppingList && elementFromSp2 is ShoppingList) {
        subElementDiffs[elementId] = Diff<S, GoListModel>.diff(
            elementFromSp1.items as List<S>, elementFromSp2.items as List<S>);
      }
    }
  }

  bool isEmpty() =>
      elementsToUpdateInLocalStorage.isEmpty &&
      elementsToUpdateInRemoteStorage.isEmpty &&
      subElementDiffs.isEmpty;
}
