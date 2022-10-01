import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoListIcons {
  static const String defaultAsset = "default";

  static String _iconPath(String name) {
    return "assets/icons/$name.png";
  }

  static Widget _icon(String name) {
    return Image.asset(
      _iconPath(name),
      color: Colors.white,
      fit: BoxFit.contain,
    );
  }

  static Widget defaultIcon() {
    return _icon(defaultAsset);
  }

  static Future<Widget> tryGetIcon(String name) async {
    try {
      await rootBundle.load(_iconPath(name));
      return _icon(name);
    } catch (_) {
      return Future.value(defaultIcon());
    }
  }
}
