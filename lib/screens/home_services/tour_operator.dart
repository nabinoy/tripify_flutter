import 'package:flutter/material.dart';

class TourOperatorSceen extends StatefulWidget {
  static const String routeName = '/tour_operator';
  const TourOperatorSceen({super.key});

  @override
  State<TourOperatorSceen> createState() => _TourOperatorSceenState();
}

class _TourOperatorSceenState extends State<TourOperatorSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(),
          SliverToBoxAdapter(
            child: Container(child: Text('Tour operator')),
          )
        ],
      ),
    );
  }
}
