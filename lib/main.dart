import 'package:flutter/material.dart';
import 'package:infinite_feed/feature/screens/feed/feed_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'infinite_feed',
      debugShowCheckedModeBanner: false,
      home: FeedView(),
    );
  }
}
