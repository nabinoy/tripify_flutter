import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/restaurant_response_model.dart';
import 'package:tripify/screens/home_services/restaurant_details.dart';
import 'package:tripify/services/api_service.dart';

late List<String> _selectedIslandChips;
late List<String> _selectedFoodChips;

class FilterRestaurant extends StatefulWidget {
  static const String routeName = '/filter_restaurant';
  const FilterRestaurant({super.key});

  @override
  State<FilterRestaurant> createState() => _FilterRestaurantState();
}

class _FilterRestaurantState extends State<FilterRestaurant> {
  bool isInit = true;
  int page = 1;
  int isEndLoading = 1;
  late Future dataFuture;
  int restaurantCount = 1;
  List<Restaurants> rd = [];
  List<Restaurants> temp = [];
  final controller = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    dataFuture = APIService.restaurantCount().then((value) async => {
          restaurantCount = value,
          await APIService.restaurantAll().then((value) => {rd = value}),
        });
    _selectedFoodChips = ['All'];
    _selectedIslandChips = ['All'];
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (_selectedFoodChips.contains('All') &&
            _selectedIslandChips.contains('All')) {
          fetch();
        } else {
          fetchWithFilter();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    page = 1;
    _selectedIslandChips.clear();
    super.dispose();
  }

  Future fetch() async {
    List<Restaurants> temp = [];
    page++;
    await APIService.allRestaurantPagination(page.toString())
        .then((value) => {temp = value});
    setState(() {
      rd.addAll(temp);
    });
  }

  Future fetchWithFilter() async {
    List<Restaurants> temp = [];
    page++;
    await APIService.restaurantPaginationFoodType(_selectedIslandChips.first,
            _selectedFoodChips.first, page.toString())
        .then((value) => {temp = value});
    setState(() {
      rd.addAll(temp);
    });
  }

  Future setData() async {
    setState(() {
      rd.clear();
      rd = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    List<IslandAll> ia = arguments[0] as List<IslandAll>;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return SingleChildScrollView(
                        child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Filter',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'By food type',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(children: [
                                  FilterChip(
                                    showCheckmark: false,
                                    selectedColor: Colors.blue[300],
                                    label: const Text("All"),
                                    selected:
                                        _selectedFoodChips.contains("All"),
                                    onSelected: (_) => setState(() {
                                      _selectedFoodChips.clear();
                                      _selectedFoodChips.add("All");
                                    }),
                                  ),
                                  const SizedBox(width: 5),
                                  FilterChip(
                                    showCheckmark: false,
                                    selectedColor: Colors.green[300],
                                    label: const Text("Veg"),
                                    selected:
                                        _selectedFoodChips.contains("Veg"),
                                    onSelected: (_) => setState(() {
                                      _selectedFoodChips.clear();
                                      _selectedFoodChips.add("Veg");
                                    }),
                                  ),
                                  const SizedBox(width: 5),
                                  FilterChip(
                                    showCheckmark: false,
                                    selectedColor: Colors.red[300],
                                    label: const Text("Non-Veg"),
                                    selected:
                                        _selectedFoodChips.contains("Non-Veg"),
                                    onSelected: (_) => setState(() {
                                      _selectedFoodChips.clear();
                                      _selectedFoodChips.add("Non-Veg");
                                    }),
                                  )
                                ]),
                                const SizedBox(
                                  height: 6,
                                ),
                                const Text(
                                  'By island',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: List.generate(
                                      ia.length + 1,
                                      (index) => (index == 0)
                                          ? FilterChip(
                                              showCheckmark: false,
                                              selectedColor:
                                                  Colors.lightBlue[300],
                                              label: const Text("All"),
                                              selected: _selectedIslandChips
                                                  .contains("All"),
                                              onSelected: (_) => setState(() {
                                                _selectedIslandChips.clear();
                                                _selectedIslandChips.add("All");
                                              }),
                                            )
                                          : FilterChip(
                                              showCheckmark: false,
                                              selectedColor:
                                                  Colors.lightBlue[300],
                                              label: Text(ia[index - 1].name),
                                              selected: _selectedIslandChips
                                                  .contains(ia[index - 1].sId),
                                              onSelected: (_) => setState(() {
                                                _selectedIslandChips.clear();
                                                _selectedIslandChips
                                                    .add(ia[index - 1].sId);
                                              }),
                                            )),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              .4,
                                      height: 40,
                                      onPressed: () {
                                        setState(
                                          () {
                                            _selectedFoodChips = ['All'];
                                            _selectedIslandChips = ['All'];
                                          },
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 2,
                                              color: Color.fromRGBO(
                                                  2, 119, 189, 1)),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Text(
                                        "Reset",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(2, 119, 189, 1),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ),
                                    MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              .4,
                                      height: 40,
                                      onPressed: () async {
                                        page = 1;
                                        isEndLoading = 1;
                                        setState(() {
                                          isLoading = true;
                                        });

                                        await APIService
                                                .islandRestaurantCountFoodType(
                                                    _selectedIslandChips.first,
                                                    _selectedFoodChips.first)
                                            .then((value) async => {
                                                  restaurantCount = value,
                                                  await APIService
                                                      .restaurantByIslandIdFoodType(
                                                    _selectedIslandChips.first,
                                                    _selectedFoodChips.first,
                                                  ).then((value) => {
                                                        temp = value,
                                                        setData(),
                                                        setState(() {
                                                          isLoading = false;
                                                        })
                                                      })
                                                });

                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        // HapticFeedback.mediumImpact();
                                      },
                                      color: Colors.lightBlue[800],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: isLoading
                                          ? const SizedBox(
                                              height: 20.0,
                                              width: 20.0,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              "Apply",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                    )
                                  ],
                                )
                              ],
                            )),
                      );
                    });
                  },
                );
              },
              child: Container(
                  margin: const EdgeInsets.all(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.lightBlue[800],
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Filter',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(Icons.filter_list_outlined,
                          size: 16, color: Colors.white)
                    ],
                  )),
            )
          ],
        ),
        body: FutureBuilder(
          future: dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (rd.isEmpty) {
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
                        'No restaurant found!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                if (restaurantCount <= (page * restaurantPageSize)) {
                  isEndLoading = 0;
                }
                return ListView.builder(
                    controller: (isEndLoading == 0) ? null : controller,
                    itemCount: rd.length + isEndLoading,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      if (index < rd.length) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RestaurantDetailsPage.routeName,
                                arguments: [rd[index]]);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2.0,
                                  blurRadius: 5.0,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .25,
                                      width: MediaQuery.of(context).size.width *
                                          .25,
                                      imageUrl:
                                          rd[index].images.first.secureUrl,
                                      placeholder: (context, url) =>
                                          Image.memory(
                                        kTransparentImage,
                                        fit: BoxFit.cover,
                                      ),
                                      fadeInDuration:
                                          const Duration(milliseconds: 200),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .55,
                                      child: Text(
                                        rd[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .55,
                                      child: Text(rd[index].address.city,
                                          style: const TextStyle(fontSize: 12)),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Icon(
                                      MdiIcons.squareCircle,
                                      size: 18,
                                      color: (rd[index].isVeg)
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    });
              }
            } else {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ));
  }
}
