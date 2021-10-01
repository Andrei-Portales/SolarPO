import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:solar_app/screens/result_screen.dart';
import 'package:solar_app/util/parameters.dart';
import 'package:solar_app/widgets/widget_to_image.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResultCardMonth extends StatefulWidget {
  const ResultCardMonth({
    Key? key,
    required this.keyD,
    required this.widget,
    required this.data,
  }) : super(key: key);

  final ResultScreen widget;
  final Map<String, dynamic> data;
  final String keyD;

  @override
  State<ResultCardMonth> createState() => _ResultCardMonthState();
}

class _ResultCardMonthState extends State<ResultCardMonth> {
  late ZoomPanBehavior _zoomPanBehavior;
  GlobalKey? _globalKey;

  Future<void> _capturePng() async {
    try {
      if (_globalKey == null) return;

      RenderRepaintBoundary boundary = _globalKey!.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();

      File file = File('${directory.path}/${widget.keyD}.png');
      await file.writeAsBytes(pngBytes);

      await ShareExtend.share(file.path, 'image');
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
              content: SnackBar(
            content: Text('Cant share chart...'),
          )),
        );
    }
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: _capturePng, icon: const Icon(Icons.share)),
              ],
            ),
            WidgetToImage(
              builder: (key) {
                this._globalKey = key;
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        '${paramKeys[widget.keyD]} (${widget.widget.temporalType})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      SfCartesianChart(
                          zoomPanBehavior: _zoomPanBehavior,
                          primaryXAxis: CategoryAxis(),
                          series: <LineSeries<String, String>>[
                            LineSeries<String, String>(
                              dataSource:
                                  widget.data[widget.keyD].keys.toList(),
                              xValueMapper: (String key1, _) => key1,
                              yValueMapper: (String key1, _) =>
                                  widget.data[widget.keyD][key1],
                            )
                          ]),
                      const SizedBox(height: 5),
                      Text(
                        'Units: ${widget.widget.data['parameters'][widget.keyD]['units']}',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
