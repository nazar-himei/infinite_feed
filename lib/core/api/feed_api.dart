import 'package:infinite_feed/core/api/dio_client.dart';

/// [FeedAPI] provide API videos.
class FeedAPI {
  const FeedAPI._();

  /// Fetch data from API and return data.
  static Future<dynamic> fetchVideos() async {
    final response = await DioClient.client.get('/videos/main-feed');
    return response.data;
  }

  /// Download video from [url] after save in local [filePath].
  static Future<void> downloadFile(
    String url, {
    required String filePath,
  }) =>
      DioClient.client.download(
        url,
        filePath,
      );
}
