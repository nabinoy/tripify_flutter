import 'package:flutter/material.dart';
import 'package:tripify/models/home_main_model.dart';

late List<String> _selectedCategoryChips;
late List<String> _selectedIslandChips;

class FilterPlace extends StatefulWidget {
  static const String routeName = '/filter_place';
  const FilterPlace({super.key});

  @override
  State<FilterPlace> createState() => _FilterPlaceState();
}

class _FilterPlaceState extends State<FilterPlace> {
  double _startValue = 1;
  double _endValue = 5;

  @override
  void initState() {
    _selectedCategoryChips = [];
    _selectedIslandChips = [];
    super.initState();
  }

  @override
  void dispose() {
    _selectedCategoryChips.clear();
    _selectedIslandChips.clear();
    super.dispose();
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
                                    fontSize: 26, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'By category',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Wrap(
                                spacing: 8.0,
                                children: c.map((item) {
                                  return FilterChip(
                                    selectedColor: Colors.lightBlue[300],
                                    label: Text(item.name),
                                    selected: _selectedCategoryChips
                                        .contains(item.name),
                                    onSelected: (_) => setState(() {
                                      if (_selectedCategoryChips
                                          .contains(item.name)) {
                                        _selectedCategoryChips
                                            .remove(item.name);
                                      } else {
                                        _selectedCategoryChips.add(item.name);
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
                                    fontSize: 16, fontWeight: FontWeight.w600),
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
                                              if (_selectedIslandChips
                                                  .contains("All")) {
                                                _selectedIslandChips
                                                    .remove("All");
                                              } else {
                                                _selectedIslandChips.clear();
                                                _selectedIslandChips.add("All");
                                              }
                                            }),
                                          )
                                        : FilterChip(
                                            showCheckmark: false,
                                            selectedColor: Colors.green[300],
                                            label: Text(ia[index - 1].name),
                                            selected: _selectedIslandChips
                                                .contains(ia[index - 1].sId),
                                            onSelected: (_) => setState(() {
                                              if (_selectedIslandChips.contains(
                                                  ia[index - 1].sId)) {
                                                _selectedIslandChips
                                                    .remove(ia[index - 1].sId);
                                              } else {
                                                _selectedIslandChips.clear();
                                                _selectedIslandChips
                                                    .add(ia[index - 1].sId);
                                              }
                                            }),
                                          )),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'By rating',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Column(
                                children: [
                                  RangeSlider(
                                    values: RangeValues(_startValue, _endValue),
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
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          '2',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          '3',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          '4',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          '5',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
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
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                .4,
                                        height: 40,
                                        onPressed: () {
                                          setState(
                                            () {
                                              _selectedCategoryChips.clear();
                                              _selectedIslandChips.clear();
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
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                .4,
                                        height: 40,
                                        onPressed: () {
                                          // HapticFeedback.mediumImpact();
                                          // Navigator.pushNamed(
                                          //     context, SignupPage.routeName);
                                        },
                                        color: Colors.lightBlue[800],
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Text(
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
                      style:
                          TextStyle(fontSize: 16, color: Colors.lightBlue[800]),
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
    );
  }
}
