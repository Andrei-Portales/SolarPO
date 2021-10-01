import 'package:flutter/material.dart';

class DateSelect extends StatefulWidget {
  final void Function(DateTime time, int cTime) setTime;
  final DateTime startTime;
  final DateTime endTime;

  const DateSelect({
    required this.setTime,
    required this.startTime,
    required this.endTime,
    Key? key,
  }) : super(key: key);

  @override
  _DateSelectState createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  Future<void> setDate(int cTime) async {
    final date = await showDatePicker(
      context: context,
      initialDate: cTime == 0 ? widget.startTime : widget.endTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      widget.setTime(date, cTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Start Date: '),
            InkWell(
              onTap: () => setDate(0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(7),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Center(
                    child: Text(
                  widget.startTime.toString().split(' ').first,
                  style: const TextStyle(fontSize: 20),
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('End Date: '),
            InkWell(
              onTap: () => setDate(1),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(7),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Center(
                    child: Text(
                  widget.endTime.toString().split(' ').first,
                  style: const TextStyle(fontSize: 20),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
