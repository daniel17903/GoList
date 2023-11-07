import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/local_storage_provider.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:provider/provider.dart';

import 'get_storage_mock.dart';

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
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.llfbandit.app_links/messages'),
          (MethodCall methodCall) async {
    return null;
  });
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.llfbandit.app_links/events'),
          (MethodCall methodCall) async {
    return null;
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

Future<void> pumpWithGlobalAppState(
    WidgetTester tester,
    Widget w,
    ShoppingListCollection shoppingLists,
    ShoppingList selectedShoppingList) async {
  await pump(tester,
      wrapWithGlobalAppStateProvider(shoppingLists, selectedShoppingList, w),
      withImages: true);
}

ChangeNotifierProvider<GlobalAppState> wrapWithGlobalAppStateProvider(
    ShoppingListCollection shoppingLists,
    ShoppingList selectedShoppingList,
    Widget w) {
  var goListClient = GoListClient();
  var globalAppState = GlobalAppState(
      goListClient: goListClient,
      localStorageProvider: LocalStorageProvider(MockStorage()),
      remoteStorageProvider: RemoteStorageProvider(goListClient));
  globalAppState.setShoppingLists(shoppingLists);
  globalAppState.setSelectedShoppingListId(selectedShoppingList.id);
  return ChangeNotifierProvider<GlobalAppState>.value(
      value: globalAppState, child: wrapWithMaterialApp(w));
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
