import 'dart:io';
import 'package:infinite_feed/core/models/video.dart';
import 'package:infinite_feed/core/repository/auth_repository.dart';
import 'package:infinite_feed/core/repository/feed_repository.dart';
import 'package:infinite_feed/utils/device_info.dart';
import 'package:infinite_feed/utils/request_status.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

/// [FeedViewModel] Provide you ViewModel for work with video / auth data.
class FeedViewModel extends FutureViewModel {
  final _videos = <VideoModel>[];

  /// List videos for API[fetchFeed]
  List<VideoModel> get videos => _videos;

  RequestStatus _requestStatus = RequestStatus.request;

  /// Status for handle API
  RequestStatus get requestStatus => _requestStatus;

  int _currentVideo = 0;

  /// Get index the video in page builder.
  int get getCurrentVideo => _currentVideo;

  bool _isAuthUser = false;

  /// Type for use authentication in the system
  bool get isAuthUser => _isAuthUser;

  late final Directory _temporaryDir;

  /// Provide some info about status request
  bool get isLoadingState =>
      _requestStatus == RequestStatus.request || _videos.isEmpty;

  /// [isLastVideoInFeed] For show if it's last video in list
  bool isLastVideoInFeed(int currentIndex) {
    if (_videos.isEmpty) {
      return false;
    }
    return currentIndex == _videos.length - 1;
  }

  /// Initial to fetch data from API(videos ,authentication user in system)
  Future<void> initial() async {
    _temporaryDir = await getTemporaryDirectory();

    await checkAuth();
    await fetchFeed(
      cleanVideos: true,
    );
  }

  /// Check status user authentication from API [AuthRepository.checkAuth]
  Future<void> checkAuth() async {
    try {
      final videoFeed = await AuthRepository.checkAuth();
      final userAuth = videoFeed.message?.contains('ok') ?? false;
      updateUserAuthStatus(statusAuth: userAuth);
    } catch (_) {
      updateUserAuthStatus(statusAuth: false);
      updateRequestStatus(RequestStatus.failure);
    }
  }

  /// Fetch videos from API [FeedRepository.fetchVideos].
  ///
  /// Method has updated video collection and set pagination for videos.
  /// If something happened with load data from API request status will [RequestStatus.failure]
  Future<void> fetchFeed({
    bool cleanVideos = false,
    int currentIndexPagination = 0,
  }) async {
    try {
      updateRequestStatus(RequestStatus.request);

      final videoFeed = await FeedRepository.fetchVideos();
      updateVideos(
        videoFeed,
        cleanVideos: cleanVideos,
      );
      paginationVideo(
        currentIndexPagination,
        waitForFirst: cleanVideos,
      );
      updateRequestStatus(RequestStatus.success);
    } catch (_) {
      updateRequestStatus(RequestStatus.failure);
      rethrow;
    }
  }

  /// Pagination videos from API [FeedRepository.fetchVideos]
  ///
  /// [currentIndex] Current index in builder videos.
  /// [waitForFirst] Wait first element in list videos.
  void paginationVideo(
    int currentIndex, {
    bool waitForFirst = false,
  }) async {
    final isLastVideo = currentIndex == _videos.length - 1;
    updateCurrentVideoIndex(currentIndex);

    if (isLastVideo) {
      await fetchFeed(
        currentIndexPagination: currentIndex,
      );
    }

    final filterForVideo = filterForVideos.map(
      downloadVideo,
    );
    Future.wait(filterForVideo);

    if (waitForFirst) {
      updateRequestStatus(RequestStatus.request);
      await filterForVideo.first;
      updateRequestStatus(RequestStatus.success);
    }
  }

  /// This method return list where [video.filePath] is empty.
  List<VideoModel> get filterForVideos {
    return _videos
        .where(
          (video) => video.filePath == null,
        )
        .toList();
  }

  /// Update video from repository.
  ///
  /// [videos] type for add new videos to [_videos].
  /// [cleanVideos] clean all list videos.
  void updateVideos(
    List<VideoModel> videos, {
    bool cleanVideos = false,
  }) {
    if (videos.isEmpty) {
      return;
    }

    if (cleanVideos) {
      _videos.clear();
    }

    _videos.addAll(videos);
    notifyListeners();
  }

  /// Download video from the API [FeedRepository.downloadVideo]
  ///
  /// [VideoModel] more detail about vide and get url video for download video.
  Future<void> downloadVideo(VideoModel video) async {
    try {
      final downloadedVideo = await FeedRepository.downloadVideo(
        video: video,
        file: File(join(_temporaryDir.path, '${DeviceInfo.uuid.v4()}.mp4')),
      );

      final indexAt = videos.indexWhere(
        (e) => e.id == video.id,
      );

      _videos[indexAt] = _videos[indexAt].copyWith(
        filePath: downloadedVideo.filePath,
      );
      notifyListeners();
    } catch (_) {
      updateRequestStatus(RequestStatus.failure);
    }
  }

  /// Update status request video.
  ///
  /// [RequestStatus] can be state [loading, failed, successful].
  void updateRequestStatus(RequestStatus status) {
    _requestStatus = status;
    notifyListeners();
  }

  /// Update status if user authentication
  void updateUserAuthStatus({bool statusAuth = false}) {
    _isAuthUser = statusAuth;
    notifyListeners();
  }

  /// Update current video index in builder.
  void updateCurrentVideoIndex(int currentVideo) {
    _currentVideo = currentVideo;
  }

  @override
  Future futureToRun() async {
    await initial();
  }
}
