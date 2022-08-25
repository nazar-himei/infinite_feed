import 'package:flutter/material.dart';

/// Widget provide [LinearProgressIndicator] for show progress a video
class VideoProgress extends StatelessWidget {
  const VideoProgress({
    Key? key,
    this.progressValue = 0.0,
    this.backgroundColor = Colors.grey,
    this.valueColor = Colors.black45,
  }) : super(key: key);

  /// Value for calculate progress in videos
  final double progressValue;

  /// Background color for widget
  final Color backgroundColor;

  /// Color for widget [LinearProgressIndicator]
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 5,
      value: progressValue,
      valueColor: AlwaysStoppedAnimation<Color>(
        valueColor,
      ),
      backgroundColor: backgroundColor,
    );
  }
}
