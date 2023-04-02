import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoaderReviewAll extends StatelessWidget {
  const LoaderReviewAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.grey,
                    height: 40,
                    width: 70,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 12,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 12,
                    width: 50,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    color: Colors.grey,
                    height: 10,
                    width: 140,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 10,
                    width: 140,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 10,
                    width: 140,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 10,
                    width: 140,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 10,
                    width: 140,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          const InsideLoaderReviewAll(),
          const SizedBox(
            height: 10,
          ),
          const InsideLoaderReviewAll(),
          const SizedBox(
            height: 10,
          ),
          const InsideLoaderReviewAll(),
        ]));
  }
}

class InsideLoaderReviewAll extends StatelessWidget {
  const InsideLoaderReviewAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey[300] as Color,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(12),
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
    );
  }
}
