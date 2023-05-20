import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/itinerary_request_model.dart';
import 'package:tripify/screens/itinerary/itinerary_detail.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
          title: const Text(
            'Itinerary Generator',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Welcome to our personalized itinerary generator!',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[800]),
                  ),
                ),
                const Text(
                  'Plan your dream vacation effortlessly with our innovative machine learning technology. Simply select your desired categories, choose an island, and specify the number of days you have available. Our intelligent system will curate a tailor-made itinerary just for you, ensuring a seamless and unforgettable experience.',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 18,
                ),
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
                    setState(
                      () {
                        _selectedCategoryChips.clear();
                        _selectedIslandChips = ['All'];
                        days = 3;
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: Colors.lightBlue[800]!,
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "Reset",
                    style: TextStyle(
                        color: Colors.lightBlue[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: () {
                    HapticFeedback.mediumImpact();

                    ItineraryModel model = ItineraryModel(
                        days: days.toInt(),
                        lat: currentLoc.latitude!,
                        long: currentLoc.longitude!);
                    
                    Navigator.pushNamed(context, ItineraryDetails.routeName,arguments: [model,_selectedCategoryChips,_selectedIslandChips]);
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
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
