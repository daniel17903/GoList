import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/local_storage_provider.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await LocalStorageProvider.init();

  runApp(ChangeNotifierProvider<GlobalAppState>(
      create: (context) {
        final goListClient = GoListClient();
        final globalAppState = GlobalAppState(
            goListClient: goListClient,
            localStorageProvider: LocalStorageProvider(),
            remoteStorageProvider: RemoteStorageProvider(goListClient));
        globalAppState.loadListsFromStorage();
        return globalAppState;
      },
      builder: (context, child) => PlatformProvider(
            settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
            builder: (context) => PlatformTheme(
                builder: (context) => Consumer<GlobalAppState>(
                      builder: (context, globalAppState, child) => PlatformApp(
                          debugShowCheckedModeBanner: false,
                          localizationsDelegates:
                              AppLocalizations.localizationsDelegates,
                          supportedLocales: AppLocalizations.supportedLocales,
                          locale: globalAppState.locale,
                          title: 'GoList',
                          home: child),
                      child: const ShoppingListPage(),
                    )),
          )));
}
