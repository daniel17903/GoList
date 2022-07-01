import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/style/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemedApp extends StatelessWidget {
  final Widget child;

  ThemedApp({Key? key, required this.child}) : super(key: key);

  final materialTheme = ThemeData(
      backgroundColor: GoListColors.darkBlue,
      cardColor: const Color(0x94024461),
      bottomAppBarTheme: const BottomAppBarTheme(
          shape: CircularNotchedRectangle(), color: Color(0xff005382)),
      colorScheme: const ColorScheme(
          secondary: Color(0xff005382),
          brightness: Brightness.light,
          primary: Color(0xffff8888),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          background: Colors.blue,
          onBackground: Colors.green,
          surface: Colors.red,
          onSurface: Colors.yellow,
          error: Colors.grey,
          onError: Colors.grey));

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: materialTheme,
      child: PlatformProvider(
        settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
        builder: (context) {
          //PlatformProvider.of(context)?.changeToCupertinoPlatform();
          return PlatformApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            //locale: Locale('de', ''),
            title: 'GoList',
            home: child,
            material: (_, __) => MaterialAppData(
              theme: materialTheme,
            ),
            cupertino: (_, __) => CupertinoAppData(
              theme: const CupertinoThemeData(
                primaryColor: Color(0xff127EFB),
              ),
            ),
          );
        },
      ),
    );
  }
}
