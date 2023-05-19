import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TranslatorWebView extends StatefulWidget {
  static const String routeName = '/translatorwebview';
  const TranslatorWebView({super.key});

  get controller => null;

  @override
  State<TranslatorWebView> createState() => _TranslatorWebViewState();
}

class _TranslatorWebViewState extends State<TranslatorWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://translate.google.co.in/'),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Translator',
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
