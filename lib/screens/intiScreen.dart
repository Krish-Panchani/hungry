import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/belowAppbar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/Add%20Location/LocationDetails.dart';
import 'package:hunger/screens/Add%20Location/addLocationDetails.dart';
import 'package:hunger/screens/addFood/FoodDetailsScreen.dart';
import 'package:hunger/screens/addFood/addFoodDetails.dart';
import 'package:hunger/screens/main/screens/home_screen.dart';
import 'package:hunger/screens/sign_in/sign_in_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  late String _currentAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentAddress(); // Fetch current address
  }

  Future<void> _getCurrentAddress() async {
    // Fetch current address here
    // For example, you can use Geocoding or any other method to get the address
    // For now, let's assume _currentAddress is fetched successfully
    _currentAddress = "123 Main St, City, Country"; // Example address
    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AddressBox(
            initialAddress: _currentAddress,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Are You Hungry??'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              HomeScreen(currentAddress: _currentAddress),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: kPrimaryColor, // Text color
                      padding: const EdgeInsets.all(16), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                      elevation: 5, // Elevation (shadow)
                      minimumSize: const Size(double.infinity, 0), // Full width
                    ),
                    child: const Text(
                      'Find Food',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('You have Remaining Food??'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        // User is logged in
                        DocumentSnapshot userSnapshot = await FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(user.uid)
                            .get();

                        if (userSnapshot.exists) {
                          // User data exists in Firestore, navigate to FoodDetailsScreen
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const FoodDetailsScreen(),
                            ),
                          );
                        } else {
                          // User is logged in but does not have data in users collection
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const AddFoodDetails(),
                            ),
                          );
                        }
                      } else {
                        // User is not logged in, navigate to SignInScreen
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SignInScreen(
                                buttonPressed: "Submit Remaining Food"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                      backgroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.all(16), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: kPrimaryColor,
                          width: 2.0,
                        ), // Rounded corners
                      ),
                      elevation: 5, // Elevation (shadow)
                      minimumSize: const Size(double.infinity, 0), // Full width
                    ),
                    child: const Text(
                      'Submit Remaining Food',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Want to help us??'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        // User is logged in
                        DocumentSnapshot locationSnapshot =
                            await FirebaseFirestore.instance
                                .collection("location")
                                .doc(user.uid)
                                .get();

                        if (locationSnapshot.exists) {
                          // User data exists in Firestore location collection, navigate to FoodDetailsScreen
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  const LocationDetailsScreen(),
                            ),
                          );
                        } else {
                          // User is logged in but does not have data in location collection
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const AddLocationDetails(),
                            ),
                          );
                        }
                      } else {
                        // User is not logged in, navigate to SignInScreen
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SignInScreen(
                                buttonPressed: "Add more Locations"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                      backgroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.all(16), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: kPrimaryColor,
                          width: 2.0,
                        ), // Rounded corners
                      ),
                      elevation: 5, // Elevation (shadow)
                      minimumSize: const Size(double.infinity, 0), // Full width
                    ),
                    child: const Text(
                      'Add more Locations',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
