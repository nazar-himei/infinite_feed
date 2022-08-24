import 'dart:io';
import 'package:infinite_feed/core/models/video.dart';
import 'package:infinite_feed/core/repository/auth_repository.dart';
import 'package:infinite_feed/core/repository/feed_repository.dart';
import 'package:infinite_feed/utils/device_info.dart';
import 'package:infinite_feed/utils/request_status.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

class FeedViewModel extends FutureViewModel {
  final _videos = <Video>[];
  List<Video> get videos => _videos;

  RequestStatus _requestVideosStatus = RequestStatus.loading;
  RequestStatus get requestVideosStatus => _requestVideosStatus;

  int _currentVideo = 0;
  int get getCurrentVideo => _currentVideo;

  bool _isAuthUser = false;
  bool get isAuthUser => _isAuthUser;

  late final Directory _temporaryDir;

  bool get isLoadignState =>
      _requestVideosStatus == RequestStatus.loading || _videos.isEmpty;

  bool isLastVideoInFeed(int currentIndex) {
    if (_videos.isEmpty) {
      return false;
    }
    return currentIndex == _videos.length - 1;
  }

  Future<void> initial() async {
    _temporaryDir = await getTemporaryDirectory();

    await checkAuth();
    await fetchFeed(
      cleanVideos: true,
    );
  }

  /// Featch videos from API [FeedRepository.fetchVideos].
  ///
  /// Method has updated video collection and set pagination for videos.
  Future<void> fetchFeed({
    bool cleanVideos = false,
    int currentIndexPagination = 0,
  }) async {
    try {
      updateRequestStatus(RequestStatus.loading);

      final videoFeed = await FeedRepository.fetchVideos();
      updateVideos(
        videoFeed,
        cleanVideos: cleanVideos,
      );
      paginationVideo(
        currentIndexPagination,
        waitForFirst: cleanVideos,
      );
      updateRequestStatus(RequestStatus.successful);
    } catch (_) {
      updateRequestStatus(RequestStatus.failled);
      rethrow;
    }
  }

  /// Pagination videos from API [FeedRepository.fetchVideos]
  ///
  /// [currentIndex] current index in builder videos.
  /// [waitForFirst] wait first element in list videos.
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
      updateRequestStatus(RequestStatus.loading);
      await filterForVideo.first;
      updateRequestStatus(RequestStatus.successful);
    }
  }

  /// review type file path is Empty, in collection videos [_videos]
  bool isEmptyFilePathVideo(int currentIndex) =>
      _videos[currentIndex].filePath == null;

  /// This method returner list where [video.filePath] is empty.
  List<Video> get filterForVideos {
    return _videos
        .where(
          (video) => video.filePath == null,
        )
        .toList();
  }

  /// check status user authentication from API [AuthRepository.checkAuth]
  Future<void> checkAuth() async {
    try {
      final videoFeed = await AuthRepository.checkAuth();
      final userAuth = videoFeed.message?.contains('ok') ?? false;
      updateUserAuthStatus(statusAuth: userAuth);
    } catch (_) {
      updateUserAuthStatus(statusAuth: false);
    }
  }

  /// Update video from repository.
  /// [videos] type for add new videos to [_videos].
  /// [cleanVideos] clean all list videos.
  void updateVideos(
    List<Video> videos, {
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
  /// [Video] more detail about vide and get url video for download video.
  Future<void> downloadVideo(Video video) async {
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
      updateRequestStatus(RequestStatus.failled);
    }
  }

  /// Update status request video.
  ///
  /// [RequestStatus] can be state [loading, failed, successful].
  void updateRequestStatus(RequestStatus status) {
    _requestVideosStatus = status;
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
