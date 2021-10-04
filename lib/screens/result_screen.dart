import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:solar_po/util/pdf.dart';
import '../util/transform_data.dart';
import '../widgets/result_card_daily.dart';
import '../widgets/result_card_month.dart';
import 'dart:io';
import 'dart:convert';

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
  bool _isLoadingPdf = false;

  String formatDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    return '$year-$month-$day';
  }

  Widget getGeneralText(String title, String text, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(title),
      subtitle: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  void setWidgets() {
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
                'Longitude',
                '${widget.data['geometry']['coordinates'][1].toStringAsFixed(4)}',
                Icons.location_on_outlined,
              ),
              getGeneralText(
                'Latitude',
                '${widget.data['geometry']['coordinates'][0].toStringAsFixed(4)}',
                Icons.location_on,
              ),
              getGeneralText(
                'Elevation',
                '${widget.data['geometry']['coordinates'][2]} meters',
                Icons.grain_rounded,
              ),
              getGeneralText(
                'Start time',
                '${formatDate(widget.data['header']['start'])}',
                Icons.timer,
              ),
              getGeneralText(
                'End time',
                '${formatDate(widget.data['header']['end'])}',
                Icons.timer_outlined,
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

  Future<void> _generatePdf() async {
    bool result = true;

    setState(() {
      _isLoadingPdf = true;
    });

    if (widget.temporalType == 'monthly') {
      result = await generatePdfMonthly(data: widget.data);
    } else {
      result = await generatePdfDaily(data: widget.data);
    }

    setState(() {
      _isLoadingPdf = false;
    });

    if (!result) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Cant create pdf, try again later...')),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    setWidgets();
  }

  Future<void> _shareRawData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      File file = File(
          '${directory.path}/data_${widget.temporalType}_${DateTime.now().toIso8601String()}.json');

      await file.writeAsString(json.encode(widget.data));

      await ShareExtend.share(file.path, 'application/json');
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('Cant share data, try later...'),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [
          if (!_isLoadingPdf)
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: _generatePdf,
            ),
          if (_isLoadingPdf)
            Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareRawData,
          ),
        ],
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
