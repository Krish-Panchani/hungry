import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hunger/constants.dart';

class AddressBox extends StatefulWidget {
  const AddressBox({Key? key}) : super(key: key);

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
    _getLocationPermission();
  }

  Future<void> _getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Show a snackbar to inform the user about the importance of location permission
      final snackBar = SnackBar(
        content: const Text('Location permission is mandatory for this app.'),
        action: SnackBarAction(
          label: 'Grant',
          onPressed: () async {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              _getLocationPermission();
            } else {
              // User granted permission, proceed to get location
              _getCurrentLocation();
            }
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Location permission is already granted, proceed to get location
      _getCurrentLocation();
    }
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
            "${placemark.subLocality} ${placemark.subAdministrativeArea} ${placemark.country} "
            "${placemark.postalCode}";
      } else {
        _currentAddress = "Address not found";
      }

      setState(() {
        _currentAddress = _currentAddress;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
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
                        const CircularProgressIndicator(
                          color: kSecondaryColor,
                        )
                      else if (_currentPosition != null &&
                          _currentAddress != null)
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$_currentAddress',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // const BackButton(),
            ],
          ),
        ),
      ],
    );
  }
}
