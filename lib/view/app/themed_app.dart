import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/state/locale_state.dart';
import 'package:provider/provider.dart';

class ThemedApp extends StatelessWidget {
  final Widget child;

  const ThemedApp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
      builder: (context) => PlatformTheme(
          builder: (context) => Consumer<LocaleState>(
                builder: (context, localeState, v) => PlatformApp(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: localeState.locale,
                  title: 'GoList',
                  home: child,
                ),
              )),
    );
  }
}
