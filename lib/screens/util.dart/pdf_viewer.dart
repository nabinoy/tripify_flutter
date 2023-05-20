import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  static const String routeName = '/pdf_viewer';

  const PdfViewPage({super.key});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    String url = arguments[0];
    String appBarName = arguments[1];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  _pdfViewerController.zoomLevel =
                      _pdfViewerController.zoomLevel - 0.25;
                },
                icon: const Icon(Icons.zoom_out),
              ),
              IconButton(
                onPressed: () {
                  _pdfViewerController.zoomLevel =
                      _pdfViewerController.zoomLevel + 0.25;
                },
                icon: const Icon(Icons.zoom_in),
              ),
              IconButton(
                onPressed: () {
                  _pdfViewerController.previousPage();
                },
                icon: const Icon(Icons.navigate_before),
              ),
              IconButton(
                onPressed: () {
                  _pdfViewerController.nextPage();
                },
                icon: const Icon(Icons.navigate_next),
              ),
              IconButton(
                onPressed: () {
                  _pdfViewerController.firstPage();
                },
                icon: const Icon(Icons.first_page),
              ),
              IconButton(
                onPressed: () {
                  _pdfViewerController.lastPage();
                },
                icon: const Icon(Icons.last_page),
              ),
            ],
          ),
          Expanded(
            child: SfPdfViewer.network(
              url,
              controller: _pdfViewerController,
            ),
          ),
        ],
      ),
    );
  }
}
