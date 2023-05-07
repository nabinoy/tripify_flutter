import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class WebpageLinkContainer extends StatelessWidget {
  final String name;
  final String url;
  final String logoUrl;

  WebpageLinkContainer({required this.name, required this.url, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              SvgPicture.network(
                logoUrl,
                height: 24.0,
                width: 24.0,
              ),
              SizedBox(width: 8.0),
              Text(url),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text('Open'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
