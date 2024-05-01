import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/Add%20Location/LocationDetails.dart';
import 'package:hunger/screens/intiScreen.dart';

class LocatinConfirmScreen extends StatefulWidget {
  final String firstName;
  final String phoneNumber;
  final String address;
  final String details;
  final LatLng location;
  final String id;

  const LocatinConfirmScreen({
    super.key,
    required this.firstName,
    required this.phoneNumber,
    required this.address,
    required this.details,
    required this.location,
    required this.id,
  });

  @override
  State<LocatinConfirmScreen> createState() => _LocatinConfirmScreenState();
}

class _LocatinConfirmScreenState extends State<LocatinConfirmScreen> {
  String status = ''; // variable to hold the status data

  @override
  void initState() {
    super.initState();
    getStatusFromDatabase(); // call method to fetch status data
  }

  Future<void> _refreshScreen() async {
    // Call getStatusFromDatabase again to fetch updated data
    await getStatusFromDatabase();
    // Set state to trigger a rebuild of the widget with the updated data
    setState(() {});
  }

  // Method to fetch status data from Firebase Realtime Database
  Future<void> getStatusFromDatabase() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    User? auth = FirebaseAuth.instance.currentUser;
    databaseReference
        .child('locations')
        .child(auth!.uid)
        .child(widget.id)
        .child('status')
        .once()
        .then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          status = event.snapshot.value
              .toString(); // update status variable with fetched data
        });
      }
    }).catchError((error) {
      print('Failed to fetch status: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(showLogOut: true),
      body: RefreshIndicator(
        onRefresh: _refreshScreen,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Thank you',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'For your Contribution',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Your details has been updated after approval,'),
                    Text('We will Contact you soon for verification.'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Here is your Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 1.5,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: 'Location Name: ',
                                        style: kTextStyleB),
                                    TextSpan(
                                        text: widget.firstName,
                                        style: kTextStyleN),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: 'Location Address: ',
                                        style: kTextStyleB),
                                    TextSpan(
                                        text: widget.address,
                                        style: kTextStyleN),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: 'Details: ', style: kTextStyleB),
                                    TextSpan(
                                        text: widget.details,
                                        style: kTextStyleN),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: 'Phone: ', style: kTextStyleB),
                                    TextSpan(
                                        text: widget.phoneNumber,
                                        style: kTextStyleN),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: 'Status: ', style: kTextStyleB),
                                    TextSpan(text: status, style: kTextStyleN),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: kPrimaryColor, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const LocationDetailsScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
