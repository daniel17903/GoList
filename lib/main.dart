import 'package:flutter/material.dart';
import 'package:go_list/service/local_database.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:get/get.dart';

void main() async {
  await Get.put(LocalDatabase()).initStorage();
  runApp(MaterialApp(
    title: 'Shopping App',
    home: Container(
        color: GoListColors.darkBlue,
        constraints: const BoxConstraints.expand(),
        child: ShoppingListPage()),
  ));
}
