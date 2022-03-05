import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/service/local_database.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:get/get.dart';

void main() async {
  await Get.put(LocalDatabase()).initStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            home: const ShoppingListPage(),
            material: (_, __) =>
                MaterialAppData(
                  theme: materialTheme,
                ),
            cupertino: (_, __) =>
                CupertinoAppData(
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
