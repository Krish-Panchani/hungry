// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:hunger/components/customElevatedButton.dart';
import 'package:hunger/constants.dart';

class MapScreen3 extends StatefulWidget {
  const MapScreen3({
    Key? key,
    required this.foodNgoName,
    required this.firstName,
    required this.phoneNumber,
    required this.address,
  }) : super(key: key);
  final String foodNgoName;
  final String firstName;
  final String phoneNumber;
  final String address;

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
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Select Location',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, selectedLocation);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 15.0,
            ),
            onTap: _onMapTapped,
            markers: _markers,
          ),
          Positioned(
            bottom: 16,
            right: 90,
            child: CustomElevatedButton(
              onPressed: _selectCurrentLocation,
              text: "Select Current Location",
            ),
          ),
        ],
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
        markerId: const MarkerId("currentLocation"),
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
    _updateMarkers();
  }

  void _updateMarkers() {
    _markers.clear();
    if (selectedLocation != null) {
      _markers.add(Marker(
        markerId: const MarkerId("selectedLocation"),
        position: selectedLocation!,
        infoWindow: const InfoWindow(
          title: 'Selected Location',
        ),
      ));
    }
  }

  void _selectCurrentLocation() {
    getUserCurrentLocation().then((value) {
      setState(() {
        selectedLocation = LatLng(value.latitude, value.longitude);
      });
      _updateMarkers();
    });
  }
}
