import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/models/UserModal.dart';
import 'package:hunger/screens/main/screens/SeeAllScreen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

// Function to calculate the distance between two points using Haversine formula
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}

class BottomSlider extends StatefulWidget {
  const BottomSlider({Key? key}) : super(key: key);

  @override
  _BottomSliderState createState() => _BottomSliderState();
}

class _BottomSliderState extends State<BottomSlider> {
  final PanelController _panelController = PanelController();

  bool _showSeeAll = false;

  double? userLat;
  double? userLon;

  late DatabaseReference _databaseRef;

  StreamSubscription<dynamic>? _userDataSubscription;
  List<UserData> _userDataList = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchUserData();
  }

  // Function to get user's current location
  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLat = position.latitude;
      userLon = position.longitude;
    });
  }

  // Function to fetch user data from Firebase Realtime Database
  void _fetchUserData() {
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
            });
          }
        });

        // Filter data based on distance less than 20 km
        _userDataList = _userDataList.where((userData) {
          double locationLat = double.parse(userData.location.split(',')[0]);
          double locationLon = double.parse(userData.location.split(',')[1]);
          double distance = userLat != null && userLon != null
              ? calculateDistance(userLat!, userLon!, locationLat, locationLon)
              : 0.0; // Handle null user location
          return distance < 20.0;
        }).toList();

        // Sort the data based on increasing distance
        _userDataList.sort((a, b) {
          double locationLatA = double.parse(a.location.split(',')[0]);
          double locationLonA = double.parse(a.location.split(',')[1]);
          double distanceA = userLat != null && userLon != null
              ? calculateDistance(
                  userLat!, userLon!, locationLatA, locationLonA)
              : 0.0;

          double locationLatB = double.parse(b.location.split(',')[0]);
          double locationLonB = double.parse(b.location.split(',')[1]);
          double distanceB = userLat != null && userLon != null
              ? calculateDistance(
                  userLat!, userLon!, locationLatB, locationLonB)
              : 0.0;

          return distanceA.compareTo(distanceB);
        });

        setState(() {}); // Refresh the UI
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      borderRadius: BorderRadius.circular(24.0),
      controller: _panelController,
      minHeight: _showSeeAll ? 60 : 200,
      panel: buildPanel(),
      isDraggable: true,
      parallaxEnabled: true,
      defaultPanelState: PanelState.CLOSED,
    );
  }

  Widget buildPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        border: Border(
          top: BorderSide(
            color: kPrimaryColor, // Change border color if needed
            width: 3.0,
          ),
          left: BorderSide(
            color: kPrimaryColor, // Change border color if needed
            width: 3.0,
          ),
          right: BorderSide(
            color: kPrimaryColor, // Change border color if needed
            width: 3.0,
          ),
        ),
      ),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.drag_handle, color: Colors.black, size: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const SeeAllScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _userDataList.isEmpty
                ? const Center(child: Text('No data available'))
                : ListView.builder(
                    itemCount: _userDataList.length,
                    itemBuilder: (context, index) {
                      var userData = _userDataList[index];
                      double locationLat =
                          double.parse(userData.location.split(',')[0]);
                      double locationLon =
                          double.parse(userData.location.split(',')[1]);
                      double distance = userLat != null && userLon != null
                          ? calculateDistance(
                              userLat!, userLon!, locationLat, locationLon)
                          : 0.0; // Handle null user location
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color:
                                kPrimaryColor, // Change border color if needed
                            width: 2.0,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10.0),
                          leading: const Icon(
                            Icons.location_on_outlined,
                            size: 50,
                            color: kPrimaryColor, // Change icon color if needed
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userData.fname,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  visualDensity: const VisualDensity(
                                    horizontal: -4,
                                    vertical: -2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                      color:
                                          kPrimaryColor, // Change button color if needed
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showSeeAll = true;
                                  });
                                  _panelController.close();
                                  print(
                                      'Directions pressed for ${userData.fname}');
                                  // _launchMapsApp(locationLat, locationLon);
                                },
                                child: Text(
                                  '${distance.toStringAsFixed(2)} km',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color:
                                          kPrimaryColor), // Change button color if needed
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userData.address),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          kPrimaryColor, // Change button color if needed
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showSeeAll = true;
                                      });
                                      _panelController.close();
                                      print(
                                          'Directions pressed for ${userData.fname}');
                                      _launchMapsApp(locationLat, locationLon);
                                    },
                                    icon: const Icon(Icons.directions),
                                    label: const Text(
                                      'Directions',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'View Details',
                                    style: TextStyle(
                                      color:
                                          kPrimaryColor, // Change text color if needed
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          kPrimaryColor, // Change text color if needed
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _launchMapsApp(double destinationLat, double destinationLon) async {
    // Check if the maps application is installed
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLon';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }
}
