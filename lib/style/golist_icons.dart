import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoListIcons {
  static const String defaultIconAssetName = "default";
  late Future<List<String>> existingAssetsFuture;

  static final GoListIcons _instance = GoListIcons._internal();

  factory GoListIcons() {
    return _instance;
  }

  GoListIcons._internal() {
    existingAssetsFuture = rootBundle
        .loadString('AssetManifest.json')
        .then(jsonDecode)
        .then((assetEntriesInManifest) => assetEntriesInManifest.keys.toList());
  }

  String _iconPath(String name) {
    return "assets/icons/$name.png";
  }

  Future<bool> _assetForIconWithNameExists(String name) async {
    return existingAssetsFuture
        .then((existingAssets) => existingAssets.contains(_iconPath(name)));
  }

  Widget getIconImageWidget(String name) {
    return FutureBuilder<bool>(
        future: _assetForIconWithNameExists(name),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          String existingImageAssetName = defaultIconAssetName;
          if (snapshot.hasData) {
            existingImageAssetName =
                snapshot.data! ? name : defaultIconAssetName;
          } else if (snapshot.hasError) {
            existingImageAssetName = defaultIconAssetName;
            if (kDebugMode) {
              print("Error loading item image: ${snapshot.error}");
            }
          }

          return Image.asset(
            _iconPath(existingImageAssetName),
            color: Colors.white,
            fit: BoxFit.contain,
          );
        });
  }
}
