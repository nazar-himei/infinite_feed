import 'dart:io';
import 'package:infinite_feed/core/models/video.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends BaseViewModel {
  VideoViewModel({
    required Video video,
  }) : _video = video;

  final Video _video;

  late VideoPlayerController? playerController;

  bool get isInvalidVideo =>
      playerController != null && _video.filePath != null;

  /// initial video set settings for play video
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

  /// handle on tap video, callback play / pause video.
  void handleOnTapVideo() {
    if (!isInvalidVideo) {
      return;
    }

    if (playerController!.value.isPlaying) {
      return pauseVideo();
    }

    playVideo();
  }

  void playVideo() async => await playerController?.play();

  void pauseVideo() async => await playerController?.pause();

  /// Parse video value from builder form show progress video
  ///
  /// [value] for lisining controller change duration on video.
  double parseVideoProgress(VideoPlayerValue value) {
    final position = value.position.inMicroseconds;
    final duration = value.duration.inMicroseconds;
    final progress = position / duration;

    if (progress.isNaN) {
      return 0.0;
    }

    return progress;
  }

  /// method for dispose controller and finish play video.
  Future<void> disposeVideo() async {
    await playerController?.dispose();
  }
}
