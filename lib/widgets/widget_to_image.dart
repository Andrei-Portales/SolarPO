import 'package:flutter/material.dart';

class WidgetToImage extends StatefulWidget {
  final Function(GlobalKey key) builder;
  WidgetToImage({required this.builder});
  @override
  _WidgetToImageState createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {
  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey();

    return RepaintBoundary(
      key: globalKey,
      child: widget.builder(globalKey),
    );
  }
}
