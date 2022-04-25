import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingListWidget extends HookConsumerWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ShoppingList? currentShoppingList =
        ref.watch(AppStateNotifier.appStateProvider).currentShoppingList;
    final int otherDevicesCount =
        currentShoppingList != null ? currentShoppingList.deviceCount - 1 : 0;
    final List<Item> items = ref.watch(AppStateNotifier.currentItemsProvider);
    final String name =
        ref.watch(AppStateNotifier.currentShoppingListNameProvider);
    final bool connected = ref.watch(AppStateNotifier.connectedProvider);

    final List<Item> itemDeleteQueue = [];
    int runningItemAnimationsCounter = 0;

    void _deleteItemIfLastAnimationEnded(Item item) {
      itemDeleteQueue.add(item);
      if (runningItemAnimationsCounter == 0) {
        ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .deleteItems(itemDeleteQueue);
        itemDeleteQueue.clear();
      }
    }

    return ItemListViewer(
      itemColor: Theme.of(context).cardColor,
      parentWidth: MediaQuery.of(context).size.width,
      darkBackground: false,
      items: items,
      header: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name,
                style: const TextStyle(color: Colors.white, fontSize: 22)),
            connected
                ? const Icon(Icons.circle, color: Colors.white)
                : const Icon(Icons.circle_outlined, color: Colors.white)
          ],
        ),
      ),
      footer: otherDevicesCount != 0
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.0),
                    color: const Color(0x50000000),
                  ),
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                  child: Text("Mit $otherDevicesCount anderen Geräten geteilt",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic)),
                ),
              ),
            )
          : null,
      onPullForRefresh: ref
          .read(AppStateNotifier.appStateProvider.notifier)
          .loadAllFromStorage,
      onItemTapped: (tappedItem) {
        runningItemAnimationsCounter++;
      },
      onItemAnimationEnd: (itemWithEndedAnimation) {
        runningItemAnimationsCounter--;
        _deleteItemIfLastAnimationEnded(itemWithEndedAnimation);
      },
      onItemTappedLong: (item) => DialogUtils.showSmallAlertDialog(
          context: context, content: EditItemDialog(item: item)),
      delayItemTap: true,
    );
  }
}
