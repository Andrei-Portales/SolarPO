import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:share_extend/share_extend.dart';
import 'package:solar_po/util/parameters.dart';
import 'package:solar_po/util/transform_data.dart';
import 'dart:convert';
import 'dart:io';

String formatDate(String date) {
  String year = date.substring(0, 4);
  String month = date.substring(4, 6);
  String day = date.substring(6, 8);
  return '$year-$month-$day';
}

Future<dynamic> fetch(String url, String body) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
    );

    final result = json.decode(response.body);

    if (result['result'] == false) {
      return null;
    }

    return result['images'];
  } catch (e) {
    return null;
  }
}

Future<bool> generatePdfMonthly({
  required Map<dynamic, dynamic> data,
}) async {
  try {
    Map<String, dynamic> dataC = monthlyData(data['properties']['parameter']);

    final resultImages = await fetch(
      'http://198.199.123.112:2000/monthly',
      json.encode({
        'data': dataC.keys
            .map(
              (e) => ({
                'key': e,
                'data': dataC[e],
                'units': data['parameters'][e]['units'],
              }),
            )
            .toList()
      }),
    );

    if (resultImages == null) {
      return false;
    }

    List<pw.Widget> imagesBytes = [];

    for (dynamic im in resultImages) {
      final response = await http.get(Uri.parse(im['image']));
      imagesBytes.add(
        pw.Container(
          width: double.infinity,
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 25),
              pw.Text(
                '${paramKeys[im['key']]}',
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.SizedBox(height: 10),
              pw.SizedBox(
                width: 400,
                height: 220,
                child: pw.Image(
                  pw.MemoryImage(
                    response.bodyBytes,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'Summary',
                style: pw.TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text(
                'Longitude: ${data['geometry']['coordinates'][1].toStringAsFixed(4)}',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text(
                'Latitude: ${data['geometry']['coordinates'][0].toStringAsFixed(4)}',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text('Elevation: ${data['geometry']['coordinates'][2]} meters',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text('Start time:  ${formatDate(data['header']['start'])}',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text('End time: ${formatDate(data['header']['end'])}',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 20),
            pw.Text(
              'Charts:',
              style: pw.TextStyle(fontSize: 18),
            ),
            ...imagesBytes,
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();

    File file = File('${directory.path}/summary_${DateTime.now()}.pdf');
    await file.writeAsBytes(await pdf.save());
    await ShareExtend.share(file.path, 'application/pdf');
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> generatePdfDaily({
  required Map<dynamic, dynamic> data,
}) async {
  try {
    Map<String, dynamic> dataC = dailyData(data['properties']['parameter']);

    final resultImages = await fetch(
      'http://198.199.123.112:2000/daily',
      json.encode({
        'data': dataC.keys
            .map(
              (e) => ({
                'key': e,
                'data': dataC[e],
                'units': data['parameters'][e]['units'],
              }),
            )
            .toList()
      }),
    );

    if (resultImages == null) {
      return false;
    }

    List finalItems = [];
    int currentIndex = 0;

    for (var item in resultImages) {
      final sub = item['data'];
      for (var year in sub.keys) {
        for (var month in sub[year]) {
          if (finalItems.length == 0) {
            finalItems.add([]);
          }

          if (finalItems[currentIndex].length == 3) {
            finalItems.add([]);
            currentIndex++;
          }

          finalItems[currentIndex].add({
            'month': month['month'],
            'image': (await http.get(Uri.parse(month['data']))).bodyBytes,
          });
        }
      }
    }

    List<pw.Widget> imagesBytes = [];

    for (dynamic im in resultImages) {
      imagesBytes.add(
        pw.Container(
          width: double.infinity,
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 25),
              pw.Text(
                '${paramKeys[im['key']]}',
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.SizedBox(height: 25),
              ...finalItems.map((e) {
                return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      ...e.map<pw.Widget>((item) {
                        return pw.Container(
                          height: 150,
                          width: 150,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Text('${item['month']}'),
                                pw.SizedBox(height: 10),
                                pw.Image(pw.MemoryImage(item['image'])),
                              ]),
                        );
                      }),
                    ]);
              }),
            ],
          ),
        ),
      );
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'Summary',
                style: pw.TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text(
                'Longitude: ${data['geometry']['coordinates'][1].toStringAsFixed(4)}',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text(
                'Latitude: ${data['geometry']['coordinates'][0].toStringAsFixed(4)}',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text('Elevation: ${data['geometry']['coordinates'][2]} meters',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text('Start time:  ${formatDate(data['header']['start'])}',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text('End time: ${formatDate(data['header']['end'])}',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 20),
            pw.Text(
              'Charts:',
              style: pw.TextStyle(fontSize: 18),
            ),
            ...imagesBytes,
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();

    File file = File('${directory.path}/summary_${DateTime.now()}.pdf');
    await file.writeAsBytes(await pdf.save());
    await ShareExtend.share(file.path, 'application/pdf');
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
