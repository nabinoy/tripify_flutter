import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/models/home_main_model.dart';

class FilterPlace extends StatefulWidget {
  static const String routeName = '/filter_place';
  const FilterPlace({super.key});

  @override
  State<FilterPlace> createState() => _FilterPlaceState();
}

class _FilterPlaceState extends State<FilterPlace> {
  double _startValue = 2;
  double _endValue = 4;

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
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              useSafeArea: true,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
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
                                  onSelected: (bool value) {},
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
                              children: ia.map((item) {
                                return FilterChip(
                                  selectedColor: Colors.lightBlue[300],
                                  label: Text(item.name),
                                  onSelected: (bool value) {},
                                );
                              }).toList(),
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
                                        // HapticFeedback.mediumImpact();
                                        // Navigator.pushNamed(
                                        //     context, LoginPage.routeName);
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
          child: const Text('Open Bottom Sheet'),
        ),
      ),
    );
  }
}