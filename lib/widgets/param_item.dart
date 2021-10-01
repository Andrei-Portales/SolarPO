import 'package:flutter/material.dart';

class ParamItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final int currentIndex;
  final void Function(int main, int sub) setSelected;

  const ParamItem({
    required this.data,
    required this.currentIndex,
    required this.setSelected,
    Key? key,
  }) : super(key: key);

  @override
  _ParamItemState createState() => _ParamItemState();
}

class _ParamItemState extends State<ParamItem> {
  bool _isOpen = false;

  void setSelected(int sub) {
    widget.setSelected(widget.currentIndex, sub);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isOpen = !_isOpen;
                });
              },
              child: ListTile(
                title: Text(widget.data['category']),
                leading: Text(
                  '${widget.data['items'].where((element) => element['isSelected'] == true).length}',
                ),
                trailing: Icon(
                  _isOpen ? Icons.arrow_downward : Icons.arrow_upward,
                ),
              ),
            ),
            _isOpen ? const Divider() : const SizedBox(),
            _isOpen
                ? Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(children: [
                      for (int i = 0; i < widget.data['items'].length; i++)
                        ListTile(
                          title: Text(widget.data['items'][i]['name']),
                          trailing: Checkbox(
                            value: widget.data['items'][i]['isSelected'],
                            onChanged: (value) {
                              setSelected(i);
                            },
                          ),
                        ),
                    ]),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
