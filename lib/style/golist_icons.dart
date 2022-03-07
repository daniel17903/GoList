import 'package:flutter/material.dart';

class GoListIcons {
  static Widget icon(String name) {
    return Image.asset(
      "assets/$name.png",
      color: Colors.white,
      fit: BoxFit.contain,
    );
  }
}
