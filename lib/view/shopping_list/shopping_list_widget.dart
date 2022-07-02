import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/dialog/edit_list_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingListWidget extends HookConsumerWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ShoppingList? currentShoppingList =
        ref.watch(AppStateNotifier.appStateProvider).currentShoppingList;
    final int otherDevicesCount =
        currentShoppingList != null ? currentShoppingList.deviceCount - 1 : 0;
    final ListOf<Item> items = ref.watch(AppStateNotifier.currentItemsProvider);
    final String name =
        ref.watch(AppStateNotifier.currentShoppingListNameProvider);

    return ItemListViewer(
      itemColor: Theme.of(context).cardColor,
      parentWidth: MediaQuery.of(context).size.width,
      darkBackground: false,
      items: items..sort(),
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 22)),
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.white,
            onPressed: () => DialogUtils.showSmallAlertDialog(
                context: context, content: const EditListDialog()),
          )
        ],
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
                  child: Text(
                      AppLocalizations.of(context)!
                          .shared_devices_info(otherDevicesCount),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic)),
                ),
              ),
            )
          : null,
      onPullForRefresh: () => ref
          .read(AppStateNotifier.appStateProvider.notifier)
          .loadAllFromStorage(context),
      onItemTapped: (tappedItem) {
        ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .deleteItems(ListOf([tappedItem]));
      },
      onItemTappedLong: (item) => DialogUtils.showSmallAlertDialog(
          context: context, content: EditItemDialog(item: item)),
      delayItemTap: true,
    );
  }
}
