import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoListIcons {
  static const String defaultIconAssetName = "default";
  List<String> existingAssets = [];

  static final GoListIcons _instance = GoListIcons._internal();

  factory GoListIcons() {
    return _instance;
  }

  GoListIcons._internal() {
    rootBundle
        .loadString('AssetManifest.json')
        .then((manifestContent) => json.decode(manifestContent).keys.toList())
        .then((assetEntriesInManifest) =>
            existingAssets = assetEntriesInManifest);
  }

  String _iconPath(String name) {
    return "assets/icons/$name.png";
  }

  bool _assetForIconWithNameExists(String name) {
    return existingAssets.contains(_iconPath(name));
  }

  Image getIconImageWidget(String name) {
    return Image.asset(
      _iconPath(
          _assetForIconWithNameExists(name) ? name : defaultIconAssetName),
      color: Colors.white,
      fit: BoxFit.contain,
    );
  }

  void precacheIconImage(String name, BuildContext context) {
    precacheImage(getIconImageWidget(name).image, context);
  }
}
