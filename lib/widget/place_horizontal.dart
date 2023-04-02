import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/loader/loader_place_horizontal.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/services/api_service.dart';

class PlaceHorizontal extends StatefulWidget {
  final String catId;
  final String islandId;
  const PlaceHorizontal(this.catId, this.islandId, {super.key});

  @override
  State<PlaceHorizontal> createState() => _PlaceHorizontalState();
}

class _PlaceHorizontalState extends State<PlaceHorizontal> {
  List<Places2> pd = [];
  int page = 1;
  int isEndLoading = 1;
  final controller = ScrollController();
  late Future dataFuture;
  int placeCount = 1;

  @override
  void initState() {
    super.initState();
    fetchData();
    dataFuture = APIService.placeByCategoryIsland(widget.catId, widget.islandId)
        .then((value) => {pd = value});
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    page = 1;
    controller.dispose();
    super.dispose();
  }

  Future fetchData() async {
    await APIService.islandPlaceCount(widget.catId, widget.islandId)
        .then((value) => {placeCount = value});
  }

  Future fetch() async {
    List<Places2> temp = [];
    page++;
    await APIService.placePagination(page.toString())
        .then((value) => {temp = value});
    setState(() {
      pd.addAll(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (pd.isEmpty) {
            return Container(
              padding: const EdgeInsets.only(top: 60),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.alertCircleOutline,
                    size: 58,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No places found!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (placeCount <= (page * placePageSize)) {
              isEndLoading = 0;
            }
            return ListView.builder(
                controller: (isEndLoading == 0) ? null : controller,
                itemCount: pd.length + isEndLoading,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  if (index < pd.length) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Place.routeName,
                            arguments: [pd[index]]);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(children: [
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    height:
                                        MediaQuery.of(context).size.width / 2.5,
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    imageUrl: pd[index].images.first.secureUrl,
                                    placeholder: (context, url) => Image.memory(
                                      kTransparentImage,
                                      fit: BoxFit.cover,
                                    ),
                                    fadeInDuration:
                                        const Duration(milliseconds: 200),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 15,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 17,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        pd[index].ratings.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pd[index].name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    pd[index].address.city,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                });
          }
        } else {
          return const LoaderPlaceHorizontal();
        }
      },
    );
  }
}
