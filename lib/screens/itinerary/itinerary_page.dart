import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/itinerary_request_model.dart';
import 'package:tripify/services/api_service.dart';

late List<String> _selectedCategoryChips;
late List<String> _selectedIslandChips;

class ItineraryPage extends StatefulWidget {
  static const String routeName = '/itinerary_page';
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  late List<Future> dataFuture;
  double days = 3.0;

  @override
  void initState() {
    _selectedCategoryChips = [];
    _selectedIslandChips = ['All'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CategoryAll> c = [];
    List<IslandAll> ia = [];
    late LocationData currentLoc;

    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    c = arguments[0] as List<CategoryAll>;
    ia = arguments[1] as List<IslandAll>;
    currentLoc = arguments[2];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Itinerary'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'By category',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Wrap(
                  spacing: 8.0,
                  children: c.map((item) {
                    return FilterChip(
                      selectedColor: Colors.lightBlue[300],
                      label: Text(item.name),
                      selected: _selectedCategoryChips.contains(item.sId),
                      onSelected: (_) => setState(() {
                        if (_selectedCategoryChips.contains(item.sId)) {
                          _selectedCategoryChips.remove(item.sId);
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                              selected: _selectedIslandChips.contains("All"),
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
                                _selectedIslandChips.add(ia[index - 1].sId);
                              }),
                            )),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  'Select no. of days',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SfSlider(
                  min: 1.0,
                  max: itineraryDayCount,
                  value: days,
                  interval: 1,
                  showTicks: true,
                  showLabels: true,
                  enableTooltip: true,
                  minorTicksPerInterval: 0,
                  stepSize: 1.0,
                  onChanged: (value) {
                    setState(() {
                      days = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    ItineraryModel model = ItineraryModel(days: days.toInt(), lat: currentLoc.latitude!, long: currentLoc.longitude!);
                    APIService.itineraryAll(model).then((value) => {value});
                    //Navigator.pushNamed(context, SignupPage.routeName);
                  },
                  color: Colors.lightBlue[800],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    "Get itinerary",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
