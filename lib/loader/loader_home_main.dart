import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoaderHomeMain extends StatelessWidget {
  const LoaderHomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CarouselController();
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth / 2 - 25;
    double containerHeight = containerWidth * 0.60;

    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 20,
                  width: 180,
                  color: Colors.white,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 16.0),
                margin: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 20,
                  width: 170,
                  color: Colors.white,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(right: 90.0),
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 35,
                  width: 220,
                  color: Colors.white,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(right: 90.0),
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  height: 35,
                  width: 220,
                  color: Colors.white,
                ),
              ),
              CarouselSlider.builder(
                  carouselController: controller,
                  itemCount: 3,
                  itemBuilder: (context, index, realIndex) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        height: 200,
                        width: 300,
                        color: Colors.grey,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 0.78,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                  )),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  height: 20,
                  width: 160,
                  color: Colors.white,
                ),
              ),
              Column(
                children: [
                  for (int i = 0; i < 8; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              height: containerHeight,
                              width: containerWidth,
                              color: Colors.grey,
                            ),
                          ),
                          if (i + 1 < 8)
                            Container(
                              margin: const EdgeInsets.only(left: 16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  height: containerHeight,
                                  width: containerWidth,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  height: 20,
                  width: 160,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
