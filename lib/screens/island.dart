import 'package:flutter/material.dart';
import 'package:tripify/constants/global_variables.dart';

class Island  extends StatelessWidget {
  static const String routeName = '/island';
  const Island({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
      appBar: AppBar(
        title: const Text('island'),
      ),
      body: const Center(
            child: Text(
              'You have pushed the button this many times:',
            
        ),
      ),
    )
    );
  }
}
