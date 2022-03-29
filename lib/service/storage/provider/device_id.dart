import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io' show Platform;

import 'package:uuid/uuid.dart';

class DeviceId {
  late final GetStorage getStorage;
  String? cachedDeviceId;

  DeviceId() {
    getStorage = GetStorage();
  }

  Future<void> init() async {
    String? deviceId;
    var deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId = androidDeviceInfo.androidId; // unique ID on Android
      }
    } catch (_) {}
    if (deviceId == null) {
      if (!getStorage.hasData("deviceId")) {
        getStorage.write("deviceId", const Uuid().v4());
      }
      deviceId = getStorage.read("deviceId");
    }
    cachedDeviceId = deviceId;
  }

  String call() {
    return cachedDeviceId!;
  }
}
