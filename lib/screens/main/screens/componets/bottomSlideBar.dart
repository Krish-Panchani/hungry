import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/models/UserModal.dart';
import 'package:hunger/screens/main/screens/SeeAllScreen.dart';
import 'package:shimmer/shimmer.dart';
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

// Existing imports remain unchanged

class BottomSlider extends StatefulWidget {
  const BottomSlider({Key? key}) : super(key: key);

  @override
  _BottomSliderState createState() => _BottomSliderState();
}

class _BottomSliderState extends State<BottomSlider> {
  final PanelController _panelController = PanelController();

  bool _isLoading = true;
  late bool _showSeeAll = true;
  late double? userLat;
  late double? userLon;
  late DatabaseReference _locationsRef;
  late DatabaseReference _foodBanksRef;
  late StreamSubscription<dynamic> _userDataSubscription;
  List<UserData> _userDataList = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchUserData();
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLat = position.latitude;
      userLon = position.longitude;
    });
  }

  void _fetchUserData() {
    _locationsRef = FirebaseDatabase.instance.ref().child('locations');
    _foodBanksRef = FirebaseDatabase.instance.ref().child('FoodBanks');

    _userDataSubscription = _locationsRef.onValue.listen((event) {
      _processData(event.snapshot.value, 'location');
    });

    _userDataSubscription = _foodBanksRef.onValue.listen((event) {
      _processData(event.snapshot.value, 'foodBank');
    });
  }

  void _processData(dynamic data, String type) {
    if (data != null) {
      Map<dynamic, dynamic>? usersDataMap = data as Map?;
      usersDataMap?.forEach((userId, userData) {
        Map<dynamic, dynamic>? userDataMap = userData as Map?;
        if (userDataMap != null) {
          userDataMap.forEach((id, data) {
            _userDataList.add(UserData.fromJson(data));
          });
        }
      });

      _getUserLocation().then((_) {
        if (userLat != null && userLon != null) {
          _userDataList = _userDataList.where((userData) {
            double locationLat = double.parse(userData.location.split(',')[0]);
            double locationLon = double.parse(userData.location.split(',')[1]);
            double distance =
                calculateDistance(userLat!, userLon!, locationLat, locationLon);
            return distance < 20.0;
          }).toList();

          // Sort distances after filtering
          _userDataList.sort((a, b) {
            double locationLatA = double.parse(a.location.split(',')[0]);
            double locationLonA = double.parse(a.location.split(',')[1]);
            double distanceA = calculateDistance(
                userLat!, userLon!, locationLatA, locationLonA);

            double locationLatB = double.parse(b.location.split(',')[0]);
            double locationLonB = double.parse(b.location.split(',')[1]);
            double distanceB = calculateDistance(
                userLat!, userLon!, locationLatB, locationLonB);

            return distanceA.compareTo(distanceB);
          });

          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      borderRadius: BorderRadius.circular(24.0),
      controller: _panelController,
      minHeight: _showSeeAll ? 200 : 60,
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
            color: kPrimaryColor,
            width: 3.0,
          ),
          left: BorderSide(
            color: kPrimaryColor,
            width: 3.0,
          ),
          right: BorderSide(
            color: kPrimaryColor,
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
            child: _isLoading
                ? _buildShimmerList()
                : _userDataList.isEmpty
                    ? const Center(
                        child: Text('No data available'),
                      )
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
                              : 0.0;
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: kPrimaryColor,
                                width: 2.0,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10.0),
                              leading: const Icon(
                                Icons.location_on_outlined,
                                size: 50,
                                color: kPrimaryColor,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                          color: kPrimaryColor,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showSeeAll = false;
                                      });
                                      _panelController.close();
                                      print(
                                          'Directions pressed for ${userData.fname}');
                                    },
                                    child: Text(
                                      '${distance.toStringAsFixed(2)} km',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: kPrimaryColor,
                                      ),
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
                                          backgroundColor: kPrimaryColor,
                                        ),
                                        onPressed: () {
                                          // setState(() {
                                          //   _showSeeAll = true;
                                          // });
                                          _panelController.close();
                                          print(
                                              'Directions pressed for ${userData.fname}');
                                          _launchMapsApp(
                                              locationLat, locationLon);
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
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          decorationColor: kPrimaryColor,
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

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount:
          _userDataList.length, // You can adjust the number of shimmering tiles
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              width: 50.0,
              height: 50.0,
            ),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              height: 15.0,
            ),
            subtitle: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              height: 15.0,
            ),
          ),
        );
      },
    );
  }

  void _launchMapsApp(double destinationLat, double destinationLon) async {
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLon';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    super.dispose();
  }
}
