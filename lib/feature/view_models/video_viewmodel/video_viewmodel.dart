import 'dart:io';
import 'package:infinite_feed/core/models/video.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

/// [VideoViewModel] Provide function for work with videos.
class VideoViewModel extends BaseViewModel {
  VideoViewModel({
    required VideoModel video,
  }) : _video = video;

  final VideoModel _video;

  /// [VideoPlayerController] provide controller for work with video in video builder.
  late VideoPlayerController? playerController;

  /// Checking if video valid in controller
  bool get isInvalidVideo =>
      playerController != null && _video.filePath != null;

  /// Initial video set settings for play video
  void initialVideo() async {
    playerController = VideoPlayerController.file(
      File(_video.filePath!),
    );
    startVideo();
    notifyListeners();
  }

  /// startVideo method for settings video controller.
  void startVideo() async {
    await playerController?.setLooping(true);
    await playerController?.initialize();
    await playerController?.play();
  }

  /// Handle on tap video, callback play / pause video.
  void handleOnTapVideo() {
    if (!isInvalidVideo) {
      return;
    }

    if (playerController!.value.isPlaying) {
      return pauseVideo();
    }

    playVideo();
  }

  /// Play video in video builder
  void playVideo() async => await playerController?.play();

  /// Pause video in video builder
  void pauseVideo() async => await playerController?.pause();

  /// Parse video value from builder form show progress video
  ///
  /// [value] for listening controller change duration on video.
  double parseVideoProgress(VideoPlayerValue value) {
    final position = value.position.inMicroseconds;
    final duration = value.duration.inMicroseconds;
    final progress = position / duration;

    if (progress.isNaN) {
      return 0.0;
    }

    return progress;
  }

  /// Close video in video builder.
  Future<void> closeVideo() async {
    await playerController?.dispose();
  }
}
