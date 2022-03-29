import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/style/colors.dart';

class ThemedApp extends StatelessWidget {
  final Widget child;

  ThemedApp({Key? key, required this.child}) : super(key: key);

  final materialTheme = ThemeData(
      backgroundColor: GoListColors.darkBlue,
      cardColor: Colors.cyan.shade800,
      bottomAppBarTheme: const BottomAppBarTheme(
          shape: CircularNotchedRectangle(), color: Colors.teal),
      colorScheme: const ColorScheme(
          secondary: Colors.teal,
          // fab color
          brightness: Brightness.light,
          primary: Colors.cyan,
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
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            title: 'Flutter Platform Widgets',
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
