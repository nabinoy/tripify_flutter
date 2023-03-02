import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _myKey = GlobalKey();

  void _scrollToSection() {
    RenderBox renderBox =
        _myKey.currentContext?.findRenderObject() as RenderBox;
    double offset = renderBox.localToGlobal(Offset.zero).dy;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll To Section Demo'),
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          const SizedBox(height: 20),
          const ListTile(title: Text('Section 1')),
          const ListTile(title: Text('Section 2')),
          const ListTile(title: Text('Section 3')),
          const SizedBox(height: 20),
          Container(
            key: _myKey,
            child: const Card(
              child: ListTile(
                title: Text('Section 4'),
                subtitle: Text('This is the section to scroll to'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const ListTile(title: Text('Section 5')),
          const ListTile(title: Text('Section 6')),
          const ListTile(title: Text('Section 7')),
          const SizedBox(height: 520),
          ElevatedButton(
            onPressed: _scrollToSection,
            child: const Text('Scroll to Section 4'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
