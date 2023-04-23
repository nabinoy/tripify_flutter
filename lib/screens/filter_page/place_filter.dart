import 'package:flutter/material.dart';

class FilterPlace extends StatefulWidget {
  static const String routeName = '/filter_place';
  const FilterPlace({super.key});

  @override
  State<FilterPlace> createState() => _FilterPlaceState();
}

class _FilterPlaceState extends State<FilterPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,elevation: 0,),
    );
  }
}