import 'package:flutter/material.dart';

class GoListIcons {

  static const String defaultAsset = "default";

  static Widget icon(String name) {
    try {
      return Image.asset(
        "assets/icons/$name.png",
        color: Colors.white,
        fit: BoxFit.contain,
      );
    } catch (_) {
      return icon(defaultAsset);
    }
  }
}
