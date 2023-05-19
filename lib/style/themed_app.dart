import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/service/golist_languages.dart';

class ThemedApp extends StatelessWidget {
  final Widget child;
  final Locale? locale;

  const ThemedApp({Key? key, required this.child, this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
      builder: (context) => PlatformTheme(
        builder: (context) => PlatformApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale ?? Locale(GoListLanguages.getLanguageCode()),
          title: 'GoList',
          home: child,
        ),
      ),
    );
  }
}
