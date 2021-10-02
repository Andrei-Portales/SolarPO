import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import '../screens/result_screen.dart';
import '../util/parameters.dart';
import '../widgets/widget_to_image.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResultCardDay extends StatefulWidget {
  const ResultCardDay({
    Key? key,
    required this.keyD,
    required this.widget,
    required this.data,
  }) : super(key: key);

  final ResultScreen widget;
  final Map<String, dynamic> data;
  final String keyD;

  @override
  State<ResultCardDay> createState() => _ResultCardDayState();
}

class _ResultCardDayState extends State<ResultCardDay> {
  late ZoomPanBehavior _zoomPanBehavior;
  GlobalKey? _globalKey;
  String _currentYear = '';
  String _currentMonth = '';
  List<String> _years = [];
  List<String> _months = [];

  Future<void> _capturePng() async {
    try {
      if (_globalKey == null) return;
      RenderRepaintBoundary boundary = _globalKey!.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage();
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

  void orderDropDown() {
    _years =
        widget.data[widget.keyD].keys.map<String>((e) => e.toString()).toList();

    if (_years.length > 0) {
      _currentYear = _years[0];

      _months = widget.data[widget.keyD][_currentYear].keys
          .map<String>((e) => e.toString())
          .toList();

      if (_months.length > 0) {
        _currentMonth = _months[0];
      }
    }
  }

  void onYearChanges(String value) {
    setState(() {
      _currentYear = value;
      _months = widget.data[widget.keyD][_currentYear].keys
          .map<String>((e) => e.toString())
          .toList();

      if (_months.length > 0) {
        _currentMonth = _months[0];
      }
    });
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
    );
    super.initState();
    orderDropDown();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<String>(
                      value: _currentYear,
                      onChanged: (value) => onYearChanges(value!),
                      items: _years.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                          child: Text('$e'),
                          value: e,
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 15),
                    DropdownButton<String>(
                      value: _currentMonth,
                      onChanged: (value) {
                        setState(() {
                          _currentMonth = value!;
                        });
                      },
                      items: _months.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                          child: Text('$e'),
                          value: e,
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                IconButton(
                  onPressed: _capturePng,
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
            WidgetToImage(
              builder: (key) {
                this._globalKey = key;
                return Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 5),
                      SfCartesianChart(
                          title: ChartTitle(
                              text:
                                  '${paramKeys[widget.keyD]} (${widget.widget.temporalType})'),
                          zoomPanBehavior: _zoomPanBehavior,
                          primaryXAxis: CategoryAxis(),
                          series: <LineSeries<String, String>>[
                            LineSeries<String, String>(
                              dataSource: widget
                                  .data[widget.keyD][_currentYear]
                                      [_currentMonth]
                                  .keys
                                  .map<String>((e) => e.toString())
                                  .toList(),
                              xValueMapper: (String key1, _) => key1,
                              yValueMapper: (String key1, _) =>
                                  widget.data[widget.keyD][_currentYear]
                                      [_currentMonth][key1],
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
