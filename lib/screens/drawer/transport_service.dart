import 'package:flutter/material.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TransportService extends StatefulWidget {
  static const String routeName = '/transport_service';
  const TransportService({super.key});

  @override
  State<TransportService> createState() => _TransportServiceState();
}

class _TransportServiceState extends State<TransportService>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transport service',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          indicatorWeight: 3,
          indicatorColor: Colors.lightBlue[600],
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'By air',
            ),
            Tab(
              text: 'By sea',
            ),
            Tab(
              text: 'By road',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          WebViewWidget(
              controller: WebViewController()
                ..loadRequest(
                  Uri.parse(byAir),
                )
                ..setJavaScriptMode(JavaScriptMode.unrestricted)),
          WebViewWidget(
              controller: WebViewController()
                ..loadRequest(
                  Uri.parse(bySea),
                )
                ..setJavaScriptMode(JavaScriptMode.unrestricted)),
          WebViewWidget(
              controller: WebViewController()
                ..loadRequest(
                  Uri.parse(byRoad),
                )
                ..setJavaScriptMode(JavaScriptMode.unrestricted)),
        ],
      ),
    );
  }
}
