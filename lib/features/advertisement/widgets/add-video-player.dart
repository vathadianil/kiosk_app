import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/advertisement/controllers/advertisement-controller.dart';
import 'package:video_player/video_player.dart';

class AddVideoPlayer extends StatelessWidget {
  const AddVideoPlayer({
    super.key,
    required this.adController,
  });

  final AdController adController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        if (adController.isVideoInitialized.value) {
          return AspectRatio(
            aspectRatio: adController.videoController!.value.aspectRatio,
            child: VideoPlayer(adController.videoController!),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Show loader while switching videos
        }
      }),
    );
  }
}
