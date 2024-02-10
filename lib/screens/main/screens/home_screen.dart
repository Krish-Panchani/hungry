// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/belowAppbar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/screens/main/screens/componets/bottomSlideBar.dart';

class HomeScreen extends StatefulWidget {
  final String? currentAddress;
  const HomeScreen({
    Key? key,
    this.currentAddress,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _currentAddress;

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = LatLng(23.044857, 72.6459813);

  final Set<Marker> _markers = {};
  late BitmapDescriptor _markerIcon;

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon();
    loadUserLocations();
    _currentAddress = widget.currentAddress ?? 'Loading...';
  }

  void _loadMarkerIcon() async {
    final Uint8List markerIconBytes =
        await getBytesFromAsset('assets/images/marker_icon.png', 100);
    _markerIcon = BitmapDescriptor.fromBytes(markerIconBytes);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Codec codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void loadUserLocations() {
    // Fetch users' locations from Firestore
    FirebaseFirestore.instance.collection('location').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        // Parse the location string into latitude and longitude
        var locationString = data['location'] as String;
        var locationArray = locationString.split(',');
        var latitude = double.parse(locationArray[0]);
        var longitude = double.parse(locationArray[1]);

        // Add markers for each user's location on the map
        _markers.add(Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title:
                '${data['Fname']}', // Example: Combine first name and last name for the title
            snippet: data['address'], // Show address as snippet
          ),
          icon: _markerIcon,
          // BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ));
      }
      setState(() {}); // Update the UI to reflect the changes
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: const InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(
        showLogOut: false,
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            top: AppBar().preferredSize.height + 30,
            bottom: 65,
            left: 5,
            right: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GoogleMap(
                mapToolbarEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: true,
              ),
            ),
          ),
          // Positioned(
          //   top: 70.0,
          //   right: 16.0,
          //   child: Column(
          //     children: [
          //       FloatingActionButton(
          //         onPressed: _onMapTypeButtonPressed,
          //         materialTapTargetSize: MaterialTapTargetSize.padded,
          //         backgroundColor: kPrimaryColor,
          //         child: const Icon(Icons.map, size: 35.0),
          //       ),
          //       const SizedBox(height: 10.0),
          //       FloatingActionButton(
          //         onPressed: _onAddMarkerButtonPressed,
          //         materialTapTargetSize: MaterialTapTargetSize.padded,
          //         backgroundColor: kPrimaryColor,
          //         child: const Icon(Icons.add_location, size: 35.0),
          //       ),
          //       const SizedBox(height: 10.0),
          //       FloatingActionButton(
          //         backgroundColor: kPrimaryColor,
          //         onPressed: () async {
          //           getUserCurrentLocation().then((value) async {
          //             print("${value.latitude} ${value.longitude}");

          //             _markers.add(Marker(
          //               markerId: const MarkerId("2"),
          //               position: LatLng(value.latitude, value.longitude),
          //               infoWindow: const InfoWindow(
          //                 title: 'My Current Location',
          //               ),
          //             ));

          //             CameraPosition cameraPosition = CameraPosition(
          //               target: LatLng(value.latitude, value.longitude),
          //               zoom: 14,
          //             );

          //             final GoogleMapController controller =
          //                 await _controller.future;
          //             controller.animateCamera(
          //                 CameraUpdate.newCameraPosition(cameraPosition));
          //             setState(() {});
          //           });
          //         },
          //         child: const Icon(
          //           Icons.location_searching,
          //           size: 35.0,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          AddressBox(initialAddress: _currentAddress),
          const BottomSlider(),
        ],
      ),
    );
  }
}
