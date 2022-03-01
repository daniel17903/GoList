import 'package:flutter/material.dart';
import 'package:go_list/model/shopping_list.dart';

class GoListDrawer extends StatefulWidget {
  GoListDrawer(
      {Key? key,
      required this.shoppingLists,
      required this.onListClicked,
      required this.onListCreated})
      : super(key: key);

  List<ShoppingList> shoppingLists;

  Function onListClicked;

  Function onListCreated;

  @override
  State<GoListDrawer> createState() => _GoListDrawerState();
}

class _GoListDrawerState extends State<GoListDrawer> {
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
        child: ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
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
              ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: widget.shoppingLists.length,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                        leading: const Icon(Icons.list),
                        title: Text(widget.shoppingLists[index].name),
                        onTap: () {
                          Navigator.pop(context);
                          widget.onListClicked(widget.shoppingLists[index]);
                        },
                      ))
            ]),
        ListTile(
          leading: const Icon(Icons.add),
          title: Text("Neue Liste erstellen"),
          onTap: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
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
                            widget
                                .onListCreated(newListNameInputController.text);
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
