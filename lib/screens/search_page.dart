import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/services/api_service.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/search_page';
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  final StreamController<String> _streamController = StreamController<String>();

  List<Places2> pd = [];

  bool _isEditingText = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchFocusNode.requestFocus());
    _searchController.addListener(() {
      if (_isEditingText) {
        _isEditingText = true;
        _streamController.add(_searchController.text);
      }
    });

    _streamController.stream.listen((query) {
      APIService.placeBySearch(query).then((value) {
        setState(() {
          pd = value;
          _isEditingText = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          onChanged: (query) {
            _streamController.add(query);
            _isEditingText = true;
          },
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search places',
            border: InputBorder.none,
          ),
        ),
      ),
      body: (_searchController.text.isEmpty)
          ? Container(child: Text('empty'))
          : (pd.isEmpty)
              ? Container(
                  child: Text('No data'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: pd.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (pd.isEmpty) {
                      return Container(
                        child: Text('No data'),
                      );
                    }
                    return ListTile(
                      title: Text(pd[index].name),
                    );
                  },
                ),
    );
  }
}
