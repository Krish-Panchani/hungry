import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hunger/constants.dart';
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

  @override
  void initState() {
    super.initState();
    _getUserLocation();
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('location').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  List<Widget> nearbyLocations = [];
                  List<Map<String, dynamic>> locations = [];

                  for (int index = 0; index < documents.length; index++) {
                    var userData = documents[index].data();
                    // Extracting location data from Firestore document
                    double locationLat = double.parse(
                        (userData as Map<String, dynamic>)['location']
                            .split(',')[0]);
                    double locationLon =
                        double.parse(userData['location'].split(',')[1]);
                    // Calculating distance between user and location from Firestore
                    double distance = userLat != null && userLon != null
                        ? calculateDistance(
                            userLat!, userLon!, locationLat, locationLon)
                        : 0.0; // Handle null user location
                    if (distance <= 20.0) {
                      locations.add({
                        'userData': userData,
                        'distance': distance,
                        'locationLat': locationLat,
                        'locationLon': locationLon,
                      });
                    }
                  }

                  // Sort locations by distance in increasing order
                  locations
                      .sort((a, b) => (a['distance']).compareTo(b['distance']));

                  for (var location in locations) {
                    var userData = location['userData'];
                    double distance = location['distance'];
                    double locationLat = location['locationLat'];
                    double locationLon = location['locationLon'];

                    nearbyLocations.add(
                      Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(userData)['Fname']}',
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
                                      color: kPrimaryColor,
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
                                    'Directions pressed for ${userData['Fname']}}',
                                  );

                                  // Launch maps application with route
                                  // _launchMapsApp(locationLat, locationLon);
                                },
                                child: Text(
                                  '${distance.toStringAsFixed(2)} km',
                                  // '2 km',
                                  style: const TextStyle(
                                      fontSize: 16, color: kPrimaryColor),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['address'],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: kPrimaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showSeeAll = true;
                                      });
                                      _panelController.close();
                                      print(
                                        'Directions pressed for ${userData['Fname']}',
                                      );

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
                      ),
                    );
                  }

                  if (nearbyLocations.isNotEmpty) {
                    return ListView(
                      children: nearbyLocations,
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No nearby food locations found',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
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
