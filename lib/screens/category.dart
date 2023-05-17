import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/widget/place_horizontal.dart';

class Category extends StatefulWidget {
  static const String routeName = '/category';
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<Places2> pd = [];
  List<IslandAll> ia = [];
  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    final CategoryAll categoryDetails = arguments[0];
    ia = arguments[1] as List<IslandAll>;
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
              imageUrl: categoryDetails.image.secureUrl,
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
                categoryDetails.name,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              )),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpandableText(
                categoryDetails.description,
                animation: true,
                expandText: 'show more',
                collapseText: 'show less',
                maxLines: 6,
                linkColor: Colors.blue,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: ia
                    .map((item) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.32,
                                child: PlaceHorizontal(
                                    categoryDetails.sId, item.sId)),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
