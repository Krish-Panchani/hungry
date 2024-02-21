import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/main/screens/componets/searchScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressBox extends StatefulWidget {
  final String initialAddress;

  const AddressBox({
    Key? key,
    required this.initialAddress,
  }) : super(key: key);

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCachedAddress();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      // Reverse geocode the coordinates to get the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract the address details
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        _currentAddress = "${placemark.locality}\n"
            "${placemark.subAdministrativeArea}"
            "${placemark.country}, "
            "${placemark.postalCode}";

        // Cache the current address
        _cacheAddress(_currentAddress!);
      } else {
        _currentAddress = "Address not found";
      }

      setState(() {
        _currentPosition = position;
        _currentAddress = _currentAddress;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadCachedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedAddress = prefs.getString('cachedAddress');
    if (cachedAddress != null) {
      setState(() {
        _currentAddress = cachedAddress;
      });
    }
  }

  Future<void> _cacheAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cachedAddress', address);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 40,
                color: kPrimaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: 100.0,
                                height: 15.0,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: double.infinity - 200,
                                height: 15.0,
                              ),
                            ],
                          ),
                        )
                      else
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchScreen(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _currentAddress!,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
