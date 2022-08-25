import 'dart:io';
import 'package:infinite_feed/core/api/feed_api.dart';
import 'package:infinite_feed/core/models/video.dart';

/// [FeedRepository] provide data about videos
class FeedRepository {
  const FeedRepository._();

  /// Fetch videos from API and convert data to type [List<VideoModel>]
  static Future<List<VideoModel>> fetchVideos() async {
    final data = await FeedAPI.fetchVideos();
    return List.of(data)
        .cast<Map<String, dynamic>>()
        .map(VideoModel.fromMap)
        .toList();
  }

  /// Download video from API and save to [file]
  static Future<VideoModel> downloadVideo({
    required VideoModel video,
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
