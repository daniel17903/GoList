import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceId {
  late final GetStorage getStorage;
  String? cachedDeviceId;

  DeviceId() {
    getStorage = GetStorage();
  }

  Future<String> call() async {
    await GetStorage.init();
    String? deviceId;
    if (getStorage.hasData("deviceId")) {
      deviceId = getStorage.read("deviceId");
    } else {
      deviceId = const Uuid().v4();
      getStorage.write("deviceId", deviceId);
    }
    return deviceId!;
  }
}
