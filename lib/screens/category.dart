import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/widget/place_horizontal.dart';

class Category extends StatefulWidget {
  static const String routeName = '/category';
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
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
          flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
            height: 300,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            imageUrl: categoryDetails.first.image.secureUrl,
            placeholder: (context, url) => Image.memory(
              kTransparentImage,
              fit: BoxFit.cover,
            ),
            fadeInDuration: const Duration(milliseconds: 200),
            fit: BoxFit.cover,
          )),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
                child: Text(
              categoryDetails.first.name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            )),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(categoryDetails.first.description),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
              padding: const EdgeInsets.all(16),
              child: const PlaceHorizontal()),
        ),
      ],
    ));
  }
}
