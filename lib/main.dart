import 'package:flutter/material.dart';
import 'package:go_list/service/local_database.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:get/get.dart';

void main() async {
  await Get.put(LocalDatabase()).initStorage();
  runApp(MaterialApp(
    title: 'GoList',
    theme: ThemeData(
      backgroundColor: GoListColors.darkBlue,
      cardColor: Colors.cyan.shade800,
      bottomAppBarTheme: const BottomAppBarTheme(
          shape: const CircularNotchedRectangle(), color: Colors.teal),
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
        onError: Colors.grey,
      ),
    ),
    home: const ShoppingListPage(),
  ));
}
