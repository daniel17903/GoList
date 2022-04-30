import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/style/colors.dart';

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
    Size screenSize = window.physicalSize / window.devicePixelRatio;
    double radiusUnit = min(screenSize.height, screenSize.width);
    return Theme(
      data: materialTheme,
      child: PlatformProvider(
        settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
        builder: (context) {
          //PlatformProvider.of(context)?.changeToCupertinoPlatform();
          return PlatformApp(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            title: 'GoList',
            home: Container(
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                  radius: screenSize.height / radiusUnit, // 2.0 = screen height
                  center: Alignment.bottomCenter, // behind the fab
                  colors: const <Color>[
                    Color(0xffe4b2d2),
                    Color(0xffbde5ee),
                    Color(0xffd8e8af),
                    Color(0xfff6f294),
                    Color(0xff005382),
                  ],
                )),
                child: child),
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
