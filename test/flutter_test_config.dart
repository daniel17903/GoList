import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'snapshot/fixtures.dart';

// see https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // This is necessary for the InputToItemParser to work which is used
  // when entering text in the AddItemDialog
  TestWidgetsFlutterBinding.ensureInitialized();
  mockPlugins();
  await InputToItemParser().init("en");
  await loadAppFonts();
  return testMain();
}
