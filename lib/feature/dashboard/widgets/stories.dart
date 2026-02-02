import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../controller/DashboardController.dart';



Widget buildStories() {
  final DashboardController controller = Get.put(DashboardController());

  return Obx(() {
    if (controller.isLoadingStories.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.stories.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.stories.length,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemBuilder: (context, i) {
          final story = controller.stories[i];
          return GestureDetector(
            onTap: () => openStoryPlayer(context, i), // Click function
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [Colors.amber, Colors.orange, Colors.red, Colors.amber],
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(story.thumbnailUrl),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    story.title,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  });
}

void openStoryPlayer(BuildContext context, int index) {
  final DashboardController controller = Get.put(DashboardController());

  final story = controller.stories[index];

  Get.to(() => Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        Center(
          child: story.mediaType == 'video'
              ? VideoPlayerWidget(url: story.mediaUrl) // Video ke liye widget
              : Image.network(story.mediaUrl, fit: BoxFit.contain), // Image ke liye
        ),
        // Title overlay
        Positioned(
          top: 50,
          left: 20,
          child: Text(story.title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        // Close Button
        Positioned(
          top: 40,
          right: 10,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Get.back(),
          ),
        ),
      ],
    ),
  ));
}



class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}