import 'package:flutter/material.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: MySliverPersistentHeader(
                _selectedIndex,
                _onButtonPressed,
              ),
            ),
            SliverFillRemaining(
              child: Center(
                child: Text(
                  "Body Data ${_selectedIndex + 1}",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySliverPersistentHeader extends SliverPersistentHeaderDelegate {
  final List<String> _bodyData = [    "This is Body Data 1",    "This is Body Data 2",    "This is Body Data 3",    "This is Body Data 4"  ];

  final Function(int) _onButtonPressed;
  final int _selectedIndex;

  MySliverPersistentHeader(this._selectedIndex, this._onButtonPressed);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                onPressed: () => _onButtonPressed(0),
                child: Text('Button 1'),
                color:
                    _selectedIndex == 0 ? Colors.blue : Colors.white,
                textColor: _selectedIndex == 0 ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color:
                        _selectedIndex == 0 ? Colors.blue : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              MaterialButton(
                onPressed: () => _onButtonPressed(1),
                child: Text('Button 2'),
                color:
                    _selectedIndex == 1 ? Colors.blue : Colors.white,
                textColor: _selectedIndex == 1 ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color:
                        _selectedIndex == 1 ? Colors.blue : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              MaterialButton(
                onPressed: () => _onButtonPressed(2),
                child: Text('Button 3'),
                color:
                    _selectedIndex == 2 ? Colors.blue : Colors.white,
                textColor: _selectedIndex == 2 ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color:
                        _selectedIndex == 2 ? Colors.blue : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              MaterialButton(
                onPressed: () => _onButtonPressed(3),
                child: Text('Button 4'),
                color:
                    _selectedIndex == 3 ? Colors.blue : Colors.white,
                textColor: _selectedIndex == 3 ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color:
                        _selectedIndex == 3 ? Colors.blue : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
          ),
              ),
        ],
      ),
      SizedBox(height: 20),
      Text(
        _bodyData[_selectedIndex],
        style: TextStyle(fontSize: 20),
      ),
    ],
  ),
);

}

@override
double get maxExtent => 120;

@override
double get minExtent => 120;

@override
bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
