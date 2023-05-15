import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoaderPlaceHorizontal extends StatelessWidget {
  const LoaderPlaceHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          LoaderPlaceHorizontalInside(),
          LoaderPlaceHorizontalInside(),
          LoaderPlaceHorizontalInside(),
          LoaderPlaceHorizontalInside(),
        ],
      ),
    );
  }
}

class LoaderPlaceHorizontalInside extends StatelessWidget {
  const LoaderPlaceHorizontalInside({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 249, 249, 249),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Shimmer.fromColors(
              direction: ShimmerDirection.ltr,
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2.5,
                    width: MediaQuery.of(context).size.width / 1.4,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          ]),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  direction: ShimmerDirection.ltr,
                  baseColor: Colors.grey[600]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.black12,
                    height: 16,
                    width: 160,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Shimmer.fromColors(
                  direction: ShimmerDirection.ltr,
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.black38,
                    height: 14,
                    width: 140,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
