import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

List<String> bodyData = [
  "This is Body Data 1",
  "This is Body Data 2",
  "This is Body Data 3",
  "This is Body Data 4"
];

class ReviewCategories extends SliverPersistentHeaderDelegate {
  final Function(int) onButtonPressed;
  final int selectedIndex;
  ReviewCategories(this.selectedIndex, this.onButtonPressed);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: 55,
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  onButtonPressed(0);
                },
                minWidth: 60,
                color: selectedIndex == 0 ? Colors.blue : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'All',
                  style: TextStyle(
                    color: selectedIndex == 0 ? Colors.white : Colors.blue,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  onButtonPressed(1);
                },
                color: selectedIndex == 1 ? Colors.blue : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Positive',
                  style: TextStyle(
                    color: selectedIndex == 1 ? Colors.white : Colors.blue,
                  ),
                ),
              ),
              MaterialButton(
                enableFeedback: false,
                onPressed: () {
                  onButtonPressed(2);
                },
                color: selectedIndex == 2 ? Colors.blue : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Neutral',
                  style: TextStyle(
                    color: selectedIndex == 2 ? Colors.white : Colors.blue,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  onButtonPressed(3);
                },
                color: selectedIndex == 3 ? Colors.blue : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Negative',
                  style: TextStyle(
                    color: selectedIndex == 3 ? Colors.white : Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 55;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class ReviewAll extends StatefulWidget {
  static const String routeName = '/reviewAll';
  const ReviewAll({super.key});

  @override
  State<ReviewAll> createState() => _ReviewAllState();
}

class _ReviewAllState extends State<ReviewAll> {
  int selectedIndex = 0;
  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 0,
            pinned: true,
            elevation: 0,
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
            actions: [
              GestureDetector(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      MdiIcons.share,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      MdiIcons.heartOutline,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularPercentIndicator(
                    backgroundColor: const Color.fromARGB(31, 128, 128, 128),
                    radius: 50.0,
                    lineWidth: 8.0,
                    animation: true,
                    animationDuration: 2000,
                    percent: 0.7,
                    center: const Text(
                      "70.0%",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    footer: Column(
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Positive",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.green,
                  ),
                  CircularPercentIndicator(
                    backgroundColor: const Color.fromARGB(31, 128, 128, 128),
                    radius: 50.0,
                    lineWidth: 8.0,
                    animation: true,
                    animationDuration: 2000,
                    percent: 0.4,
                    center: const Text(
                      "40.0%",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    footer: Column(
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Neutral",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.blue,
                  ),
                  CircularPercentIndicator(
                    backgroundColor: const Color.fromARGB(31, 128, 128, 128),
                    radius: 50.0,
                    lineWidth: 8.0,
                    animation: true,
                    animationDuration: 2000,
                    percent: 0.3,
                    center: const Text(
                      "30.0%",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    footer: Column(
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Negative",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: ReviewCategories(
              selectedIndex,
              onButtonPressed,
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.black12,
              height: 1300,
            ),
          ),
        ],
      ),
    );
  }
}
