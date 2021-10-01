import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng location;
  const MapScreen(this.location, {Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition? _initialLocation;

  @override
  void initState() {
    super.initState();
    _initialLocation = CameraPosition(
      target: widget.location,
      zoom: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select map location'),
      ),
      body: GoogleMap(
        onTap: (LatLng location) {
          Navigator.of(context).pop(location);
        },
        mapType: MapType.normal,
        initialCameraPosition: _initialLocation!,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
