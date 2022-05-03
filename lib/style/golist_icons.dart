import 'package:flutter/material.dart';
import 'package:go_list/service/items/icon_mappings.dart';

class GoListIcons {
  static Widget icon(String name) {
    try {
      return Image.asset(
        "assets/$name.png",
        color: Colors.white,
        fit: BoxFit.contain,
      );
    } catch (_) {
      return icon(defaultIconAsset);
    }
  }
}
