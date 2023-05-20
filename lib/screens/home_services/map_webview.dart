import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/services/current_location.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapWebView extends StatefulWidget {
  static const String routeName = '/atmmapwebview';
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
        Uri.parse(
            'https://www.google.com/maps/search/atm/@${currentLocation.latitude},${currentLocation.longitude},15z'),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Maps',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}

class ToiletMapWebView extends StatefulWidget {
  static const String routeName = '/toiletmapwebview';
  const ToiletMapWebView({super.key});

  get controller => null;

  @override
  State<ToiletMapWebView> createState() => _ToiletMapWebViewState();
}

class _ToiletMapWebViewState extends State<ToiletMapWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(
            'https://www.google.com/maps/search/toilet/@${currentLocation.latitude},${currentLocation.longitude},15z'),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Maps',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}

class HospitalMapWebView extends StatefulWidget {
  static const String routeName = '/hospitalmapwebview';
  const HospitalMapWebView({super.key});

  get controller => null;

  @override
  State<HospitalMapWebView> createState() => _HospitalMapWebViewState();
}

class _HospitalMapWebViewState extends State<HospitalMapWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(
            'https://www.google.com/maps/search/hospital/@${currentLocation.latitude},${currentLocation.longitude},15z'),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Maps',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
