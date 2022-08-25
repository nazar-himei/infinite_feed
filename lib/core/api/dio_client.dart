import 'package:dio/dio.dart';
import 'package:infinite_feed/utils/device_info.dart';

/// Dio client provide you possibility to request API.
class DioClient {
  static const _baseUrl = 'https://api.claps.ai/v1';

  /// Default settings for Dio.
  /// Options for dio, base url [_baseUrl], id Device [DeviceInfo.deviceId] for header.
  static final client = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Device-Id': DeviceInfo.deviceId,
      },
      receiveTimeout: 15000,
      connectTimeout: 15000,
      sendTimeout: 15000,
    ),
  );
}
