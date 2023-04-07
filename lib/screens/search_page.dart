import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/search_page';
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchFocusNode.requestFocus());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          autofocus: true, // Set focus to the search field
          decoration: const InputDecoration(
            hintText: 'Search places',
            border: InputBorder.none,
          ),
        ),
      ),
      body: Container(
          // Page content goes here
          ),
    );
  }
}
