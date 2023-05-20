import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tripify/models/review_rating_model.dart';
import 'dart:math' as math;

int numberOfReviews = 0;
late List<String> _selectedChips;
bool isRecent = false;

List<Reviews2> allData = [];
List<Reviews2> positiveData = [];
List<Reviews2> negativeData = [];
List<Reviews2> neutralData = [];

class ReviewAll extends StatefulWidget {
  static const String routeName = '/reviewAll';

  const ReviewAll({super.key});

  @override
  State<ReviewAll> createState() => _ReviewAllState();
}

class _ReviewAllState extends State<ReviewAll> {
  int selectedIndex = 0;

  List<String> chipDataList = [];
  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void setSortBool(String value, List<String> chipValue) {
    if (value == 'Most recent') {
      setState(() {
        isRecent = true;
      });
    } else {
      setState(() {
        isRecent = false;
      });
    }
    chipDataList = chipValue;
  }

  @override
  void initState() {
    _selectedChips = [];
    super.initState();
  }

  @override
  void dispose() {
    _selectedChips.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    ReviewRatings reviewAll =
        ModalRoute.of(context)!.settings.arguments as ReviewRatings;

    List<String> sentimentName = ['All', 'Positive', 'Neutral', 'Negative'];
    List<Reviews2> filteredReviews = [];

    allData.clear();
    positiveData.clear();
    neutralData.clear();
    negativeData.clear();
    allData.clear();

    if (chipDataList.isNotEmpty) {
      for (var i = 0; i < reviewAll.reviews.length; i++) {
        if (chipDataList.contains(reviewAll.reviews[i].rating.toString())) {
          filteredReviews.add(reviewAll.reviews[i]);
        }
      }
    } else {
      for (var i = 0; i < reviewAll.reviews.length; i++) {
        filteredReviews.add(reviewAll.reviews[i]);
      }
    }

    for (int i = 0; i < filteredReviews.length; i++) {
      allData.add(filteredReviews[i]);
      if (filteredReviews[i].sentiment == 'Positive') {
        positiveData.add(filteredReviews[i]);
      }
      if (filteredReviews[i].sentiment == 'Negative') {
        negativeData.add(filteredReviews[i]);
      }
      if (filteredReviews[i].sentiment == 'Neutral') {
        neutralData.add(filteredReviews[i]);
      }
    }
    List<int> reviewTypeCount = [
      allData.length,
      positiveData.length,
      neutralData.length,
      negativeData.length
    ];

    List<List<Reviews2>> reviewTypeAll = [
      allData,
      positiveData,
      neutralData,
      negativeData
    ];

    List<Reviews2> sortedReviews = List.from(reviewTypeAll[selectedIndex]);
    if (isRecent) {
      sortedReviews.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            backgroundColor: Colors.white,
            centerTitle: true,
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
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              height: screenHeight * 0.22,
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularPercentIndicator(
                    backgroundColor: const Color.fromARGB(31, 128, 128, 128),
                    radius: screenWidth * 0.127,
                    lineWidth: 8.0,
                    animation: true,
                    animationDuration: 2000,
                    percent:
                        reviewAll.positiveResponse / reviewAll.numberOfReviews,
                    center: Text(
                      '${(reviewAll.positiveResponse / reviewAll.numberOfReviews * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: screenWidth * 0.036),
                    ),
                    footer: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.006,
                        ),
                        Text(
                          "Positive",
                          style: TextStyle(fontSize: screenWidth * 0.036),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.green,
                  ),
                  CircularPercentIndicator(
                    backgroundColor: const Color.fromARGB(31, 128, 128, 128),
                    radius: screenWidth * 0.127,
                    lineWidth: 8.0,
                    animation: true,
                    animationDuration: 2000,
                    percent:
                        reviewAll.neutralResponse / reviewAll.numberOfReviews,
                    center: Text(
                      '${(reviewAll.neutralResponse / reviewAll.numberOfReviews * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: screenWidth * 0.036),
                    ),
                    footer: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.006,
                        ),
                        Text(
                          "Neutral",
                          style: TextStyle(fontSize: screenWidth * 0.036),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.blue,
                  ),
                  CircularPercentIndicator(
                    backgroundColor: const Color.fromARGB(31, 128, 128, 128),
                    radius: screenWidth * 0.127,
                    lineWidth: 8.0,
                    animation: true,
                    animationDuration: 2000,
                    percent:
                        reviewAll.negativeResponse / reviewAll.numberOfReviews,
                    center: Text(
                      '${(reviewAll.negativeResponse / reviewAll.numberOfReviews * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: screenWidth * 0.036),
                    ),
                    footer: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.006,
                        ),
                        Text(
                          "Negative",
                          style: TextStyle(fontSize: screenWidth * 0.036),
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
          SliverPersistentHeader(
            delegate: SelectFilter(
              sentimentName[selectedIndex],
              reviewTypeCount[selectedIndex].toString(),
              isRecent,
              setSortBool,
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: (reviewTypeAll[selectedIndex].isEmpty)
                  ? Container(
                      padding: const EdgeInsets.only(top: 60),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.emoticonSadOutline,
                            size: 58,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviewTypeAll[selectedIndex].length,
                      itemBuilder: (context, index) {
                        return AllReviewWidget(
                            review: (isRecent)
                                ? sortedReviews
                                : reviewTypeAll[selectedIndex],
                            index: index);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectFilter extends SliverPersistentHeaderDelegate {
  final String sentimentName;
  final String reviewTypeName;
  final bool isRecent;
  final Function(String, List<String>) setSortBool;
  SelectFilter(
      this.sentimentName, this.reviewTypeName, this.isRecent, this.setSortBool);

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
        height: 45,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '$sentimentName ',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '($reviewTypeName)',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 111, 111, 111), fontSize: 11),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => FilterDialog(setSortBool),
                );
              },
              child: Row(
                children: [
                  (isRecent)
                      ? const Text('Most recent')
                      : const Text('Most relevant'),
                  const Icon(
                    MdiIcons.filterVariant,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  double get maxExtent => 45;

  @override
  double get minExtent => 45;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class ReviewCategories extends SliverPersistentHeaderDelegate {
  final Function(int) onButtonPressed;
  final int selectedIndex;
  ReviewCategories(this.selectedIndex, this.onButtonPressed);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: 45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            SizedBox(width: screenWidth * 0.03), // add a spacer
            MaterialButton(
              onPressed: () {
                onButtonPressed(1);
              },
              minWidth: 60,
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
            SizedBox(width: screenWidth * 0.03), // add a spacer
            MaterialButton(
              enableFeedback: false,
              onPressed: () {
                onButtonPressed(2);
              },
              minWidth: 60,
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
            SizedBox(width: screenWidth * 0.03), // add a spacer
            MaterialButton(
              onPressed: () {
                onButtonPressed(3);
              },
              minWidth: 60,
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
    );
  }

  @override
  double get maxExtent => 45;

  @override
  double get minExtent => 45;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class AllReviewWidget extends StatelessWidget {
  final List<Reviews2> review;
  final int index;

  const AllReviewWidget({Key? key, required this.review, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(review[index].date);
    if (review.isEmpty) {
      return (const Text('data'));
    } else {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey[300] as Color,
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor:
                          Color((math.Random().nextDouble() * 0x333333).toInt())
                              .withOpacity(1.0),
                      child: Text(
                        review[index].name[0],
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      review[index].name,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: review[index].rating.toDouble(),
                      ignoreGestures: true,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 16,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.blue,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  review[index].comment,
                  style: TextStyle(color: Colors.grey[700] as Color),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      );
    }
  }
}

class FilterDialog extends StatefulWidget {
  final Function(String, List<String>) setSortBool;
  const FilterDialog(this.setSortBool, {Key? key}) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String _selectedOption = (isRecent) ? 'Most recent' : 'Most relevant';

  void _handleOptionChange(String? value) {
    setState(() {
      _selectedOption = value!;
    });
  }

  void _handleChipSelection(String value) {
    setState(() {
      if (_selectedChips.contains(value)) {
        _selectedChips.remove(value);
      } else {
        _selectedChips.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Sort by:'),
                const SizedBox(
                  width: 30,
                ),
                DropdownButton<String>(
                  value: _selectedOption,
                  onChanged: _handleOptionChange,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Most relevant',
                      child: Text('Most relevant'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Most recent',
                      child: Text('Most recent'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Filter by:'),
            const SizedBox(
              height: 6,
            ),
            Wrap(
              spacing: 8.0,
              children: [
                FilterChip(
                  selectedColor: Colors.lightBlue[300],
                  label: const Text('1 star'),
                  selected: _selectedChips.contains('1'),
                  onSelected: (_) => _handleChipSelection('1'),
                ),
                FilterChip(
                  selectedColor: Colors.lightBlue[300],
                  label: const Text('2 star'),
                  selected: _selectedChips.contains('2'),
                  onSelected: (_) => _handleChipSelection('2'),
                ),
                FilterChip(
                  selectedColor: Colors.lightBlue[300],
                  label: const Text('3 star'),
                  selected: _selectedChips.contains('3'),
                  onSelected: (_) => _handleChipSelection('3'),
                ),
                FilterChip(
                  selectedColor: Colors.lightBlue[300],
                  label: const Text('4 star'),
                  selected: _selectedChips.contains('4'),
                  onSelected: (_) => _handleChipSelection('4'),
                ),
                FilterChip(
                  selectedColor: Colors.lightBlue[300],
                  label: const Text('5 star'),
                  selected: _selectedChips.contains('5'),
                  onSelected: (_) => _handleChipSelection('5'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.lightBlue[800]),
          ),
        ),
        MaterialButton(
          onPressed: () {
            widget.setSortBool(_selectedOption, _selectedChips);
            Navigator.of(context).pop();
          },
          color: Colors.lightBlue[800],
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: const Text(
            'Apply',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
