import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapWebView extends StatefulWidget {
  static const String routeName = '/mapwebview';
  const MapWebView({super.key});

  get controller => null;

  @override
  State<MapWebView> createState() => _MapWebViewState();
}

class _MapWebViewState extends State<MapWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.google.com/maps/search/atm/'),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Maps',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
