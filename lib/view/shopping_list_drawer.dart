import 'package:flutter/material.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:provider/provider.dart';

class ShoppingListDrawer extends StatefulWidget {
  const ShoppingListDrawer({Key? key}) : super(key: key);

  @override
  State<ShoppingListDrawer> createState() => _ShoppingListDrawerState();
}

class _ShoppingListDrawerState extends State<ShoppingListDrawer> {
  late final TextEditingController newListNameInputController;

  @override
  void initState() {
    super.initState();
    newListNameInputController = TextEditingController();
  }

  @override
  void dispose() {
    newListNameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        //backgroundColor: Theme.of(context).backgroundColor,
        child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
              color: Theme.of(context).bottomAppBarTheme.color,
              image: const DecorationImage(
                  image: AssetImage("assets/icon_foreground.png"),
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight)),
          child: const Text(
            'GoList',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ExpansionTile(
            title: const Text('Meine Listen'),
            initiallyExpanded: true,
            children: [
              Consumer<AppState>(
                builder: (context, appState, child) => ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: appState.shoppingLists.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                          leading: const Icon(Icons.list),
                          title: Text(appState.shoppingLists[index].name),
                          onTap: () {
                            Navigator.pop(context);
                            appState.selectedList = index;
                          },
                        )),
              )
            ]),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Neue Liste erstellen"),
          onTap: () {
            DialogUtils.showSmallAlertDialog(
                context: context,
                content: AlertDialog(
                  title: const Text('Neue Liste erstellen'),
                  content: TextFormField(
                      controller: newListNameInputController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                      )),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Abbrechen'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ShoppingList newShoppingList =
                            ShoppingList(name: newListNameInputController.text);
                        Storage().saveList(newShoppingList);
                        Provider.of<AppState>(context, listen: false)
                            .createList(newShoppingList);
                      },
                      child: const Text('Speichern'),
                    ),
                  ],
                ));
          },
        )
      ],
    ));
  }
}
