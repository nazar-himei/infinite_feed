import 'package:flutter/material.dart';

class VideoProgress extends StatelessWidget {
  const VideoProgress({
    Key? key,
    this.value = 0.0,
    this.backgroundColor = Colors.grey,
    this.valueColor = Colors.black45,
  }) : super(key: key);

  final double value;
  final Color backgroundColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 5,
      value: value.toDouble(),
      valueColor: AlwaysStoppedAnimation<Color>(
        valueColor,
      ),
      backgroundColor: backgroundColor,
    );
  }
}
