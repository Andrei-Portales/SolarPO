import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';
import '../screens/result_screen.dart';
import '../util/parameters.dart';
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
  ScreenshotController _controller = ScreenshotController();

  Future<void> _capturePng() async {
    try {
      final bytes = await _controller.capture();

      if (bytes == null) return;

      final directory = await getApplicationDocumentsDirectory();

      File file = File('${directory.path}/${widget.keyD}.png');
      await file.writeAsBytes(bytes);

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
            Screenshot(
              child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.white,
                child: Column(
                  children: [
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    SfCartesianChart(
                        title: ChartTitle(
                          text:
                              '${paramKeys[widget.keyD]} (${widget.widget.temporalType})',
                        ),
                        zoomPanBehavior: _zoomPanBehavior,
                        primaryXAxis: CategoryAxis(),
                        series: <LineSeries<String, String>>[
                          LineSeries<String, String>(
                            dataSource: widget.data[widget.keyD].keys.toList(),
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
              ),
              controller: _controller,
            )
          ],
        ),
      ),
    );
  }
}
