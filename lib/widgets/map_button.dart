import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../screens/map_screen.dart';
import 'package:location/location.dart';

class MapButton extends StatefulWidget {
  final void Function(LatLng?) setLocation;
  final LatLng? currentLocation;
  const MapButton({
    required this.setLocation,
    required this.currentLocation,
    Key? key,
  }) : super(key: key);

  @override
  State<MapButton> createState() => _MapButtonState();
}

class _MapButtonState extends State<MapButton> {
  bool _isLoadingPhoneLocation = false;

  Future<void> _openMap() async {
    LatLng location = const LatLng(15.783471, -90.230759);

    if (widget.currentLocation != null) {
      location = widget.currentLocation!;
    }

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapScreen(location),
      ),
    );

    if (result != null) {
      widget.setLocation(result);
    }
  }

  Future<void> _getPhoneLocation() async {
    setState(() {
      _isLoadingPhoneLocation = true;
    });

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingPhoneLocation = false;
        });
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _isLoadingPhoneLocation = false;
        });
        return;
      }
    }

    locationData = await location.getLocation();

    if (locationData.latitude == null && locationData.longitude == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Cant get device location')));
      setState(() {
        _isLoadingPhoneLocation = false;
      });
      return;
    }

    widget.setLocation(LatLng(locationData.latitude!, locationData.longitude!));

    setState(() {
      _isLoadingPhoneLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onLongPress: () {
            widget.setLocation(null);
          },
          onTap: _openMap,
          child: Container(
            height: 150,
            width: double.infinity,
            padding: EdgeInsets.all(widget.currentLocation == null ? 10 : 0),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.green[200],
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: widget.currentLocation == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: SvgPicture.asset('assets/icons/map.svg'),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Select map location',
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                        'https://maps.googleapis.com/maps/api/staticmap?zoom=10&size=500x300&maptype=roadmap&markers=color:red%7Clabel:L%7C${widget.currentLocation!.latitude},${widget.currentLocation!.longitude}&key=AIzaSyAmig25arr7txAPrm_EW12eX_RB2n_jPBo',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                  ),
          ),
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: _isLoadingPhoneLocation ? null : _getPhoneLocation,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(7),
              color: Colors.black,
            ),
            child: _isLoadingPhoneLocation
                ? SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Phone location',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
