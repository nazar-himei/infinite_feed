import 'dart:io';
import 'package:infinite_feed/core/api/feed_api.dart';
import 'package:infinite_feed/core/models/video.dart';

class FeedRepository {
  const FeedRepository._();

  static Future<List<Video>> fetchVideos() async {
    final data = await FeedAPI.fetchVideos();
    final parseData = List.of(data).cast<Map<String, dynamic>>();
    final videos = parseData.map(Video.fromMap).toList();

    return videos;
  }

  static Future<Video> downloadVideo({
    required Video video,
    required File file,
  }) async {
    await FeedAPI.downloadFile(
      video.url,
      filePath: file.path,
    );

    return video.copyWith(
      filePath: file.path,
    );
  }
}
