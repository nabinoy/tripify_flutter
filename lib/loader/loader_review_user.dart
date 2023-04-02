import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoaderReviewUser extends StatelessWidget {
  const LoaderReviewUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            color: Colors.grey,
            height: 23,
            width: 160,
            margin: const EdgeInsets.only(left: 16),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey[300] as Color,
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.grey.withOpacity(1.0),
                        ),
                        const SizedBox(width: 8),
                        Container(color: Colors.grey, height: 20, width: 160),
                        const SizedBox(
                          width: 4,
                        ),
                        Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.grey,
                        )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(color: Colors.grey, height: 12, width: 80),
                    const SizedBox(width: 8),
                    Container(
                      color: Colors.grey,
                      height: 12,
                      width: 60,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  color: Colors.grey,
                  height: 12,
                  width: 300,
                ),
                const SizedBox(height: 8),
                Container(
                  color: Colors.grey,
                  height: 12,
                  width: 260,
                ),
              ],
            ),
          )
        ]));
  }
}
