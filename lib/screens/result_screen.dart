import 'package:flutter/material.dart';
import 'package:solar_app/util/transform_data.dart';
import 'package:solar_app/widgets/result_card_daily.dart';
import 'package:solar_app/widgets/result_card_month.dart';

class ResultScreen extends StatefulWidget {
  final String temporalType;
  final Map data;
  const ResultScreen({
    required this.temporalType,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Widget> _widgets = [];

  List<GlobalKey> _globalKeys = [];

  Widget getGeneralText(String text) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  void setWidgets() {
    // text.substring(8, text.length)

    Map<String, dynamic> data = {};

    if (widget.temporalType == 'monthly') {
      data = monthlyData(widget.data['properties']['parameter']);
    } else if (widget.temporalType == 'daily') {
      data = dailyData(widget.data['properties']['parameter']);
    }

    _widgets = [
      Card(
        elevation: 3,
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              const Text(
                'General Data',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
              getGeneralText(
                'Longitude: ${widget.data['geometry']['coordinates'][1].toStringAsFixed(4)}',
              ),
              getGeneralText(
                'Latitude: ${widget.data['geometry']['coordinates'][0].toStringAsFixed(4)}',
              ),
              getGeneralText(
                'Elevation: ${widget.data['geometry']['coordinates'][2]} meters',
              ),
              getGeneralText(
                'Start time: ${widget.data['header']['start']}',
              ),
              getGeneralText(
                'End time: ${widget.data['header']['end']}',
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 25),
      ...data.keys.toList().reversed.map((key) {
        return Column(
          children: [
            if (widget.temporalType == 'monthly')
              ResultCardMonth(
                widget: widget,
                data: data,
                keyD: key,
              ),
            if (widget.temporalType == 'daily')
              ResultCardDay(
                keyD: key,
                widget: widget,
                data: data,
              ),
            const SizedBox(height: 25),
          ],
        );
      }),
    ];
  }

  @override
  void initState() {
    super.initState();
    setWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _widgets[index];
        },
        itemCount: _widgets.length,
      ),
    );
  }
}
