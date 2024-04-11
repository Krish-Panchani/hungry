import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/models/FoodBankModal.dart';
import 'package:url_launcher/url_launcher.dart';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}

class NearbyFoodBanks extends StatefulWidget {
  const NearbyFoodBanks({super.key});

  @override
  State<NearbyFoodBanks> createState() => _NearbyFoodBanksState();
}

class _NearbyFoodBanksState extends State<NearbyFoodBanks> {
  bool _isLoading = true;
  late double? userLat;
  late double? userLon;
  late DatabaseReference _foodBanksRef;
  late StreamSubscription<dynamic> _userDataSubscription;
  List<FoodBankData> _userDataList = [];

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
    _foodBanksRef = FirebaseDatabase.instance.ref().child('FoodBanks');

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
            _userDataList.add(FoodBankData.fromJson(data));
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
            return distance < 5.0;
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nearby Food Banks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _isLoading
              ? CircularProgressIndicator()
              : _userDataList.isEmpty
                  ? const Center(
                      child: Text('No data available'),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _userDataList.map((userData) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userData.Fname,
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
                                  onPressed: () {},
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
                      }).toList(),
                    ),
        ],
      ),
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
