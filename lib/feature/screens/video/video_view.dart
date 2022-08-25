import 'package:flutter/material.dart';
import 'package:infinite_feed/core/models/video.dart';
import 'package:infinite_feed/feature/view_models/video_viewmodel/video_viewmodel.dart';
import 'package:infinite_feed/feature/widgets/loader.dart';
import 'package:infinite_feed/feature/widgets/video_progress.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

/// [VideoView] For show user a Video
class VideoView extends StatelessWidget {
  const VideoView({
    Key? key,
    required this.video,
  }) : super(key: key);

  /// Video model provide detail about video.
  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    if (video.filePath == null) {
      return const Loader();
    }

    return ViewModelBuilder<VideoViewModel>.reactive(
      viewModelBuilder: () => VideoViewModel(
        video: video,
      ),
      onModelReady: (viewModel) => viewModel.initialVideo(),
      onDispose: (viewModel) => viewModel.closeVideo(),
      builder: (context, viewModel, _) {
        if (!viewModel.isInvalidVideo) {
          return const Loader();
        }

        final controller = viewModel.playerController!;

        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: viewModel.handleOnTapVideo,
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(
                  controller,
                ),
              ),
            ),
            ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: controller,
              builder: (_, value, __) {
                return Container(
                  width: double.maxFinite,
                  alignment: Alignment.bottomCenter,
                  child: VideoProgress(
                    progressValue: viewModel.parseVideoProgress(
                      value,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
