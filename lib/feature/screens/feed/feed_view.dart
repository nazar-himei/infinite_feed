import 'package:flutter/material.dart';
import 'package:infinite_feed/feature/screens/video/video_view.dart';
import 'package:infinite_feed/feature/view_models/feed_viewmodel/feed_viewmodel.dart';
import 'package:infinite_feed/feature/widgets/loader.dart';
import 'package:stacked/stacked.dart';

class FeedView extends StatefulWidget {
  const FeedView({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FeedView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedViewModel>.reactive(
      viewModelBuilder: FeedViewModel.new,
      builder: (
        context,
        viewModel,
        _,
      ) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black54,
          body: viewModel.isLoadignState
              ? const Loader()
              : RefreshIndicator(
                  onRefresh: () => viewModel.fetchFeed(
                    cleanVideos: true,
                  ),
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: viewModel.videos.length,
                    controller: PageController(
                      initialPage: viewModel.getCurrentVideo,
                    ),
                    itemBuilder: (_, i) => VideoView(
                      video: viewModel.videos.elementAt(i),
                    ),
                    onPageChanged: viewModel.paginationVideo,
                  ),
                ),
        );
      },
    );
  }
}
