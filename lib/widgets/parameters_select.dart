import 'package:flutter/material.dart';
import 'package:solar_app/widgets/param_item.dart';

class ParametersSelect extends StatelessWidget {
  final List<Map<String, dynamic>> parameters;
  final void Function(int, int) setSelected;
  const ParametersSelect(
      {required this.parameters, required this.setSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (int i = 0; i < parameters.length; i++)
        ParamItem(
          data: parameters[i],
          currentIndex: i,
          setSelected: setSelected,
        ),
    ]);
  }
}
