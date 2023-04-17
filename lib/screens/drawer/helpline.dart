import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplineModel {
  final String name;
  final String phone;

  HelplineModel({required this.name, required this.phone});

  factory HelplineModel.fromJson(Map<String, dynamic> json) {
    return HelplineModel(
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class Helpline extends StatefulWidget {
  static const String routeName = '/helpline';
  const Helpline({super.key});

  @override
  State<Helpline> createState() => _HelplineState();
}

class _HelplineState extends State<Helpline> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
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
          title: const Text(
            'Helpline',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
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
        body: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString('assets/json_data/helpline.json'),
          builder: (context, snapshot) {
            List<HelplineModel> helpline = [];
            if (snapshot.hasData) {
              var json = jsonDecode(snapshot.data!);
              json = json['numbers'];

              helpline = List<HelplineModel>.from(
                  json.map((item) => HelplineModel.fromJson(item)));
            }

            return ListView.builder(
              itemCount: helpline.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(helpline[index].name),
                  leading: const Icon(Icons.call),
                  subtitle: Text(helpline[index].phone),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            );
          },
        ));
  }
}
