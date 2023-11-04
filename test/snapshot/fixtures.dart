import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/state/global_app_state.dart';
import 'package:go_list/model/state/selected_shopping_list_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:provider/provider.dart';

Future<void> setViewSize(WidgetTester tester,
    {size = const Size(1080, 2220)}) async {
  tester.view.physicalSize = size;
}

void mockPlugins() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
    return '.';
  });
}

Widget wrapWithMaterialApp(Widget widget) {
  return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en', ''),
      debugShowCheckedModeBanner: false,
      home: Material(
        child: widget,
      ));
}

Future<void> loadImages(WidgetTester tester) async {
  /// current workaround for flaky image asset testing.
  /// https://github.com/flutter/flutter/issues/38997
  for (var element in find.byType(Image).evaluate()) {
    final Image widget = element.widget as Image;
    final ImageProvider image = widget.image;
    await precacheImage(image, element);
    await tester.pumpAndSettle();
  }
}

Future<void> pumpWithSelectedShoppingList(
    WidgetTester tester, Widget w, ShoppingList shoppingList,
    {withImages = true}) async {
  await pump(tester,
      wrapWithShoppingListProvider(shoppingList, wrapWithMaterialApp(w)),
      withImages: withImages);
}

Future<void> pumpWithGlobalAppState(WidgetTester tester, Widget w,
    ShoppingListCollection shoppingLists, String selectedShoppingListId) async {
  await pump(tester,
      wrapWithGlobalAppStateProvider(shoppingLists, selectedShoppingListId, w),
      withImages: true);
}

ChangeNotifierProvider<SelectedShoppingListState> wrapWithShoppingListProvider(
    ShoppingList shoppingList, Widget w) {
  return ChangeNotifierProvider<SelectedShoppingListState>.value(
      value: SelectedShoppingListState(shoppingList), child: w);
}

ChangeNotifierProvider<GlobalAppState> wrapWithGlobalAppStateProvider(
    ShoppingListCollection shoppingLists,
    String selectedShoppingListId,
    Widget w) {
  var globalAppState = GlobalAppState(Future.value("Einkaufsliste"));
  globalAppState.setShoppingLists(shoppingLists);
  globalAppState.setSelectedShoppingListId(selectedShoppingListId);
  return ChangeNotifierProvider<GlobalAppState>.value(
      value: globalAppState,
      child: wrapWithShoppingListProvider(
          shoppingLists.entryWithId(selectedShoppingListId)!,
          wrapWithMaterialApp(w)));
}

Future<void> pumpWrappedWithMaterialApp(WidgetTester tester, Widget w) async {
  await pump(tester, wrapWithMaterialApp(w));
}

Future<void> pump(WidgetTester tester, Widget w, {withImages = true}) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(w);
    if (withImages) {
      await loadImages(tester);
    }
  });
}
