import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoaderHotelCard extends StatelessWidget {
  const LoaderHotelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          LoaderLoaderHotelCardInside(),
          LoaderLoaderHotelCardInside(),
          LoaderLoaderHotelCardInside(),
        ],
      ),
    );
  }
}

class LoaderLoaderHotelCardInside extends StatelessWidget {
  const LoaderLoaderHotelCardInside({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      margin: const EdgeInsets.only(left: 20, top: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 233, 233),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.black38,
                    height: 26,
                    width: 160,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    color: Colors.black38,
                    height: 24,
                    width: 140,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
