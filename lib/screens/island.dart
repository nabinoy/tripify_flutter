import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/widget/map_island.dart';
import 'package:tripify/widget/place_horizontal.dart';

class Island extends StatefulWidget {
  static const String routeName = '/island';
  const Island({super.key});

  @override
  State<Island> createState() => _IslandState();
}

class _IslandState extends State<Island> {
  List<CategoryAll> ca = [];
  @override
  Widget build(BuildContext context) {
    final controller = CarouselController();
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    ca = arguments[0] as List<CategoryAll>;
    final IslandAll islandDetails = arguments[1];
    //final LatLng islandLocation = arguments[2];
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 350,
          pinned: true,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
              background: CarouselSlider.builder(
                  carouselController: controller,
                  itemCount: 2,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * .07),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                          width: 12,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.bottomCenter,
                          imageUrl: islandDetails.image.secureUrl,
                          placeholder: (context, url) => Image.memory(
                            kTransparentImage,
                            fit: BoxFit.cover,
                          ),
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        // : Container(
                        //     padding: EdgeInsets.only(
                        //         top: MediaQuery.of(context).size.width * .07),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20),
                        //       border: Border.all(
                        //         color: Colors.white,
                        //         width: 12,
                        //       ),
                        //     ),
                        //     child: ClipRRect(
                        //       borderRadius: BorderRadius.circular(20),
                        //       child:
                        //           MapIsland(islandLocation, islandDetails.name),
                        //     ),
                        //   )
                        ;
                  },
                  options: CarouselOptions(
                    height: 400,
                    viewportFraction: 1,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ))),
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
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
            child: Center(
                child: Text(
              islandDetails.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            )),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ExpandableText(
              islandDetails.description,
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
              children: ca
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
                              height: MediaQuery.of(context).size.width / 1.58,
                              child:
                                  PlaceHorizontal(item.sId, islandDetails.sId)),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    ));
  }
}
