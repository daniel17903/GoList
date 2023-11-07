import 'package:get_storage/get_storage.dart';
import 'package:mockito/mockito.dart';

class MockStorage extends Mock implements GetStorage {
  @override
  bool hasData(String key) {
    return false;
  }

  @override
  Future<void> write(String key, value) {
    return Future.value();
  }
}
