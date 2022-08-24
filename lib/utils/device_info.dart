import 'package:uuid/uuid.dart';

/// [DeviceInfo] provide information about device.
class DeviceInfo {
  const DeviceInfo._();

  static const uuid = Uuid();
  static final deviceId = uuid.v4();
}
