import 'package:flutter/material.dart';

class GoListIcons {
  static Widget icon(String name) {
    try {
      return Image.asset(
        "assets/$name.png",
        color: Colors.white,
        fit: BoxFit.contain,
      );
    } catch (_) {
      return icon("default");
    }
  }
}
