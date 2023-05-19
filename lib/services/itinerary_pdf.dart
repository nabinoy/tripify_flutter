import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tripify/models/place_response_model.dart';

Future<void> createPDF(List<List<Places2>> itineraryPlace) async {
  final pdf = pw.Document();

  for (var i = 0; i < itineraryPlace.length; i++) {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Table(
          children: [
            pw.TableRow(
              children: [
                pw.Text('Image',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Name',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Location',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            ...itineraryPlace[i]
                .map((item) => pw.TableRow(
                      children: [
                        pw.Text(itineraryPlace[i].indexOf(item).toString()),
                        pw.Text(item.name),
                        pw.Text(item.address.city),
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  List<int> bytes = await pdf.save();
  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/itinerary.pdf').writeAsBytes(bytes);
  await Share.shareFiles([file.path]);
}
