import 'package:flutter/material.dart';
import 'package:infinite_feed/core/models/video.dart';
import 'package:infinite_feed/feature/view_models/video_viewmodel/video_viewmodel.dart';
import 'package:infinite_feed/feature/widgets/loader.dart';
import 'package:infinite_feed/feature/widgets/video_progress.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return widget.video.filePath == null
        ? const Loader()
        : ViewModelBuilder<VideoViewModel>.reactive(
            viewModelBuilder: () => VideoViewModel(
              video: widget.video,
            ),
            onModelReady: (viewModel) => viewModel.initialVideo(),
            onDispose: (viewModel) => viewModel.disposeVideo(),
            builder: (
              context,
              viewModel,
              _,
            ) {
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
                      aspectRatio:
                          viewModel.playerController!.value.aspectRatio,
                      child: VideoPlayer(
                        viewModel.playerController!,
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
                          value: viewModel.parseVideoProgress(
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
