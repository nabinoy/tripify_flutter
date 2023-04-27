import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/services/api_service.dart';

late List<String> _selectedCategoryChips;
late List<String> _selectedIslandChips;

class FilterPlace extends StatefulWidget {
  static const String routeName = '/filter_place';
  const FilterPlace({super.key});

  @override
  State<FilterPlace> createState() => _FilterPlaceState();
}

class _FilterPlaceState extends State<FilterPlace> {
  bool isInit = true;
  double _startValue = 1;
  double _endValue = 5;
  int page = 1;
  int isEndLoading = 1;
  late Future dataFuture;
  int placeCount = 1;
  List<Places2> pd = [];
  List<Places2> placeTemp = [];
  final controller = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    dataFuture = APIService.placeCount().then((value) async => {
          placeCount = value,
          await APIService.placeAll().then((value) => {pd = value}),
        });
    _selectedCategoryChips = [];
    _selectedIslandChips = ['All'];
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (isInit) {
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
    _selectedCategoryChips.clear();
    _selectedIslandChips.clear();
    super.dispose();
  }

  Future fetch() async {
    List<Places2> temp = [];
    page++;
    await APIService.singlePlacePagination(page.toString())
        .then((value) => {temp = value});
    setState(() {
      pd.addAll(temp);
    });
  }

  Future fetchWithFilter() async {
    List<Places2> temp = [];
    page++;
    await APIService.placeFilter(
            _selectedCategoryChips, _selectedIslandChips.first, page.toString())
        .then((value) => {temp = value});
    setState(() {
      pd.addAll(temp);
    });
  }

  Future setData() async {
    setState(() {
      pd.clear();
      pd = placeTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    List<CategoryAll> c = arguments[0] as List<CategoryAll>;
    List<IslandAll> ia = arguments[1] as List<IslandAll>;

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
                                  'By category',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: c.map((item) {
                                    return FilterChip(
                                      selectedColor: Colors.lightBlue[300],
                                      label: Text(item.name),
                                      selected: _selectedCategoryChips
                                          .contains(item.sId),
                                      onSelected: (_) => setState(() {
                                        if (_selectedCategoryChips
                                            .contains(item.sId)) {
                                          _selectedCategoryChips
                                              .remove(item.sId);
                                        } else {
                                          _selectedCategoryChips.add(item.sId);
                                        }
                                      }),
                                    );
                                  }).toList(),
                                ),
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
                                              selectedColor: Colors.green[300],
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
                                              selectedColor: Colors.green[300],
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
                                  height: 6,
                                ),
                                const Text(
                                  'By rating',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Column(
                                  children: [
                                    RangeSlider(
                                      values:
                                          RangeValues(_startValue, _endValue),
                                      min: 1,
                                      max: 5,
                                      divisions: 4,
                                      onChanged: (RangeValues values) {
                                        setState(() {
                                          _startValue = values.start;
                                          _endValue = values.end;
                                        });
                                      },
                                      labels: RangeLabels(
                                        _startValue.toInt().toString(),
                                        _endValue.toInt().toString(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 23.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            '1',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            '2',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            '3',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            '4',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            '5',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MaterialButton(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
                                          height: 40,
                                          onPressed: () {
                                            setState(
                                              () {
                                                _selectedCategoryChips.clear();
                                                _selectedIslandChips = ['All'];
                                                _startValue = 1;
                                                _endValue = 5;
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
                                                color: Color.fromRGBO(
                                                    2, 119, 189, 1),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                          ),
                                        ),
                                        MaterialButton(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
                                          height: 40,
                                          onPressed: () async {
                                            page = 1;
                                            isEndLoading = 1;
                                            setState(() {
                                              isLoading = true;
                                            });

                                            await APIService.placeCountFilter(
                                                    _selectedCategoryChips,
                                                    _selectedIslandChips.first,
                                                    page.toString())
                                                .then((value) async => {
                                                      placeCount = value,
                                                      isInit = false,
                                                      await APIService.placeFilter(
                                                              _selectedCategoryChips,
                                                              _selectedIslandChips
                                                                  .first,
                                                              page.toString())
                                                          .then((value) => {
                                                                placeTemp =
                                                                    value,
                                                                setData(),
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
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
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text(
                                                  "Apply",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                        )
                                      ],
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Filter',
                        style: TextStyle(
                            fontSize: 16, color: Colors.lightBlue[800]),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Icon(Icons.filter_list_outlined,
                          size: 19, color: Colors.lightBlue[800])
                    ],
                  )),
            )
          ],
        ),
        body: FutureBuilder(
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
                    itemBuilder: (BuildContext context, int index) {
                      if (index < pd.length) {
                        return GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(context, Place.routeName,
                            //     arguments: [
                            //       [pd[index]],
                            //       (wishlistPlaceIdList.contains(pd[index].sId))
                            //           ? true
                            //           : false
                            //     ]);
                          },
                          child: Container(
                            //width: MediaQuery.of(context).size.width / 1.4,
                            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        imageUrl:
                                            pd[index].images.first.secureUrl,
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
                                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
