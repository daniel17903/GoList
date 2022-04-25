import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceId {
  late final GetStorage getStorage;
  String? cachedDeviceId;

  DeviceId() {
    getStorage = GetStorage();
  }

  String call() {
    String? deviceId;
    if (getStorage.hasData("deviceId")) {
      deviceId = getStorage.read("deviceId");
      print("reusing deviceid");
    } else {
      deviceId = const Uuid().v4();
      getStorage.write("deviceId", deviceId);
      print("new deviceid");
    }
    return deviceId!;
  }
}
