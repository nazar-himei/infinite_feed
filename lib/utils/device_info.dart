import 'package:uuid/uuid.dart';

/// [DeviceInfo] provide deviceId
class DeviceInfo {
  const DeviceInfo._();

  static const uuid = Uuid();
  static final deviceId = uuid.v4();
}
