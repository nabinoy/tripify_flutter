import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpline extends StatefulWidget {
  static const String routeName = '/helpline';
  const Helpline({super.key});

  @override
  State<Helpline> createState() => _HelplineState();
}

class _HelplineState extends State<Helpline> {

  late var data;

  Future jsonInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  String jsonString = await rootBundle.loadString('assets/json_data/helpline.json');
  data = jsonDecode(jsonString);
  print(data);
}

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void initState() {
    super.initState();
    jsonInit();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () async {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: ListView.builder(
        itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: data["numbers"][index]["name"],);
                  }
      )
      // SingleChildScrollView(
      //   child: Row(children: [
      //     const Text('Call here'),
      //     ElevatedButton(
      //       onPressed: () {
      //         _makePhoneCall('+919531839056');
      //       },
      //       child: const Text('Call'),
      //     )
      //   ]),
      // ),
    );
  }
}
