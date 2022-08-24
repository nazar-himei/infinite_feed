import 'package:infinite_feed/core/api/dio_client.dart';

class FeedAPI {
  const FeedAPI._();

  static Future<dynamic> fetchVideos() async {
    final response = await DioClient.client.get('/videos/main-feed');
    return response.data;
  }

  static Future<void> downloadFile(
    String url, {
    required String filePath,
  }) =>
      DioClient.client.download(
        url,
        filePath,
      );
}
