import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AdController extends GetxController {
  VideoPlayerController? videoController;
  RxBool isVideoInitialized = false.obs;
  RxInt currentVideoIndex = 0.obs;

  final List<String> videoAds = [
    // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    // 'https://dmmmnhobdnvpv.cloudfront.net/7%20Years%20of%20Progress%20%EF%BD%9C%EF%BD%9C%20Connections%20%EF%BD%9C%EF%BD%9C%20Milestones!%20%F0%9F%8C%9F%E2%9C%A8.mp4',
    'https://dmmmnhobdnvpv.cloudfront.net/Follow%20the%20rules%20inside%20metro%20premises.mp4',
    'https://dmmmnhobdnvpv.cloudfront.net/Metro%20Etiquette%20_%20Safe%20Travel%20_%20Hyderabad%20Metro.mp4'
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeVideo();
  }

  void _initializeVideo() {
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        videoAds[currentVideoIndex.value],
      ),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize().then((_) {
        isVideoInitialized.value = true;
        videoController!.play();
        _listenToVideoEnd();
      });
  }

  void _listenToVideoEnd() {
    videoController!.addListener(() {
      if (videoController!.value.position >= videoController!.value.duration) {
        _playNextVideo();
      }
    });
  }

  void _playNextVideo() {
    currentVideoIndex.value = (currentVideoIndex.value + 1) %
        videoAds.length; // Loop back after last video
    _restartVideo();
  }

  void _restartVideo() {
    videoController?.dispose();
    isVideoInitialized.value = false;
    _initializeVideo();
  }

  void closeAdScreen() {
    videoController?.dispose();
    Get.back();
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }
}
