import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingListWidget extends HookConsumerWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Item> items = ref.watch(AppStateNotifier.currentItemsProvider);
    final String name =
        ref.watch(AppStateNotifier.currentShoppingListNameProvider);
    final bool connected = ref.watch(AppStateNotifier.connectedProvider);

    return ItemListViewer(
      items: items,
      header: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name,
                style: const TextStyle(color: Colors.white, fontSize: 22)),
            connected ? const Icon(Icons.circle, color: Colors.white) : const Icon(Icons.circle_outlined, color: Colors.white)
          ],
        ),
      ),
      onPullForRefresh: ref
          .read(AppStateNotifier.appStateProvider.notifier)
          .loadAllFromStorage,
      onItemTapped: (tappedItem) {
        ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .deleteItem(tappedItem);
      },
      onItemTappedLong: (item) => DialogUtils.showSmallAlertDialog(
          context: context, content: EditItemDialog(item: item)),
      delayItemTap: true,
    );
  }
}
