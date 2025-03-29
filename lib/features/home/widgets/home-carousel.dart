import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_app/common/widgets/images/rounded_corner_image.dart';

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({
    super.key,
    this.applyBoxShadow = false,
    this.boxShadowColor,
  });

  final bool applyBoxShadow;
  final Color? boxShadowColor;

  @override
  Widget build(BuildContext context) {
    final pageBanners = [
      // 'https://dmmmnhobdnvpv.cloudfront.net/image-L8.jpeg',
      // 'https://dmmmnhobdnvpv.cloudfront.net/image-5.jpg',
      'https://dmmmnhobdnvpv.cloudfront.net/image-7.jpeg',
      'https://dmmmnhobdnvpv.cloudfront.net/image-L3.jpg',
      'https://dmmmnhobdnvpv.cloudfront.net/image-L4.jpg',
      // 'https://dmmmnhobdnvpv.cloudfront.net/image-L7.jpg',
      'https://dmmmnhobdnvpv.cloudfront.net/images-L2.jpg'
    ];
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        viewportFraction: 1,
        padEnds: false,
        onPageChanged: (index, reason) {
          // controller.updatePageIndicator(index);
        },
      ),
      items: pageBanners.map((bannerDetail) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: RoundedCornerImage(
                  isNetworkImage: true,
                  imageUrl: bannerDetail,
                  fit: BoxFit.cover,
                  applyBoxShadow: applyBoxShadow,
                  boxShadowColor: boxShadowColor,
                  width: double.infinity,
                  // onPressed: () => _launchURL(bannerDetail.bannerRedirectLink),
                ));
          },
        );
      }).toList(),
    );
  }
}
