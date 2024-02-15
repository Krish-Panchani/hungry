import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen3 extends StatefulWidget {
  const MapScreen3(
      {super.key,
      required String firstName,
      required String phoneNumber,
      required String address,
      required String details});

  @override
  _MapScreen3State createState() => _MapScreen3State();
}

class _MapScreen3State extends State<MapScreen3> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, selectedLocation);
            },
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 15.0,
        ),
        onTap: _onMapTapped,
        markers: Set.from(selectedLocation != null
            ? [
                Marker(
                    markerId: const MarkerId('selected'),
                    position: selectedLocation!)
              ]
            : []),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    // Add markers for the user's current location
    getUserCurrentLocation().then((value) {
      _markers.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: const InfoWindow(
          title: 'Your Current Location',
        ),
      ));

      // Center the map on the user's location
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  Future<Position> getUserCurrentLocation() async {
    // Check if location permission is already granted
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Permission not granted, request it
      await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }
}
