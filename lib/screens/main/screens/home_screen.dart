// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/belowAppbar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/screens/main/screens/componets/bottomSlideBar.dart';

class UserData {
  final String fname;
  final String address;
  final String details;
  final String location;
  final String phone;

  UserData({
    required this.fname,
    required this.address,
    required this.details,
    required this.location,
    required this.phone,
  });

  factory UserData.fromJson(Map<dynamic, dynamic> json) {
    return UserData(
      fname: json['Fname'] ?? '',
      address: json['address'] ?? '',
      details: json['details'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

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
  late DatabaseReference _databaseRef;

  StreamSubscription<dynamic>? _userDataSubscription;
  final List<UserData> _userDataList = [];

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
    _databaseRef = FirebaseDatabase.instance.ref().child('locations');
    _userDataSubscription = _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _userDataList.clear();
        // Assuming event.snapshot.value is a Map<String, dynamic>
        Map<dynamic, dynamic>? usersDataMap = event.snapshot.value as Map?;
        usersDataMap?.forEach((userId, userData) {
          // Assuming userData is a Map<String, dynamic> representing user data
          Map<dynamic, dynamic>? userDataMap = userData as Map?;
          if (userDataMap != null) {
            userDataMap.forEach((id, data) {
              _userDataList.add(UserData.fromJson(data));
              log('User Data: ${data as Map}');
              _markers.add(Marker(
                markerId: MarkerId(id.toString()),
                position: LatLng(
                  double.parse(data['location'].toString().split(',')[0]),
                  double.parse(data['location'].toString().split(',')[1]),
                ),
                infoWindow: InfoWindow(
                  title: data['Fname'],
                  snippet: data['address'],
                ),
                icon: _markerIcon,
              ));
            });
          }
        });
        setState(() {}); // Refresh the UI
      }
    });

    _databaseRef = FirebaseDatabase.instance.ref().child('FoodBanks');
    _userDataSubscription = _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _userDataList.clear();
        // Assuming event.snapshot.value is a Map<String, dynamic>
        Map<dynamic, dynamic>? usersDataMap = event.snapshot.value as Map?;
        usersDataMap?.forEach((userId, userData) {
          // Assuming userData is a Map<String, dynamic> representing user data
          Map<dynamic, dynamic>? userDataMap = userData as Map?;
          if (userDataMap != null) {
            userDataMap.forEach((id, data) {
              _userDataList.add(UserData.fromJson(data));
              log('User Data: ${data as Map}');
              _markers.add(Marker(
                markerId: MarkerId(id.toString()),
                position: LatLng(
                  double.parse(data['location'].toString().split(',')[0]),
                  double.parse(data['location'].toString().split(',')[1]),
                ),
                infoWindow: InfoWindow(
                  title: data['Fname'],
                  snippet: data['address'],
                ),
                icon: _markerIcon,
              ));
            });
          }
        });
        setState(() {}); // Refresh the UI
      }
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    getUserCurrentLocation().then((value) {
      _markers.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: const InfoWindow(
          title: 'Your Current Location',
        ),
      ));

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  Future<Position> getUserCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
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
          AddressBox(initialAddress: _currentAddress),
          const BottomSlider(),
        ],
      ),
    );
  }
}
