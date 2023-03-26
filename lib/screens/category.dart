import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/home_main_model.dart';

class Category extends StatelessWidget {
  static const String routeName = '/category';
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    List<CategoryAll> categoryDetails =
        ModalRoute.of(context)!.settings.arguments as List<CategoryAll>;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 300,
          pinned: true,
          elevation: 0,
          // flexibleSpace: FlexibleSpaceBar(
          //     background: CarouselSlider.builder(
          //         carouselController: controller,
          //         itemCount: placeList.first.images.length,
          //         itemBuilder: (context, index, realIndex) {
          //           final urlImage =
          //               placeList.first.images[index].secureUrl;
          //           return buildImage(context, urlImage, index);
          //         },
          //         options: CarouselOptions(
          //           height: 400,
          //           viewportFraction: 1,
          //           autoPlay: true,
          //           enableInfiniteScroll: true,
          //           autoPlayAnimationDuration:
          //               const Duration(seconds: 1),
          //           autoPlayCurve: Curves.fastOutSlowIn,
          //         ))),
          leading: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 20),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Text(categoryDetails.first.name),
        ),
        SliverToBoxAdapter(
          child: Text(categoryDetails.first.description),
        ),
      ],
    ));
  }
}
