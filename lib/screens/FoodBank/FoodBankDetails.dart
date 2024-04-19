// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/intiScreen.dart';

class FoodBankDetailsScreen extends StatefulWidget {
  final String ngoName;
  final String firstName;
  final String address;
  final String phone;
  FoodBankDetailsScreen({
    Key? key,
    required this.ngoName,
    required this.firstName,
    required this.address,
    required this.phone,
  }) : super(key: key);

  @override
  State<FoodBankDetailsScreen> createState() => FoodBankDetailsScreenState();
}

class FoodBankDetailsScreenState extends State<FoodBankDetailsScreen> {
  // late DatabaseReference _databaseRef;

  // StreamSubscription<dynamic>? _userDataSubscription;
  // final List<FoodBankData> _userDataList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _databaseRef = FirebaseDatabase.instance.ref().child('FoodBanks');
  //   _userDataSubscription = _databaseRef.onValue.listen((event) {
  //     if (event.snapshot.value != null) {
  //       _userDataList.clear();
  //       // Get the current user's ID
  //       String? userId = FirebaseAuth.instance.currentUser?.uid;
  //       if (userId != null) {
  //         // Assuming event.snapshot.value is a Map<String, dynamic>
  //         Map<dynamic, dynamic>? usersDataMap = event.snapshot.value as Map?;
  //         // Check if the current user's data exists in the snapshot
  //         if (usersDataMap != null && usersDataMap.containsKey(userId)) {
  //           // Retrieve the current user's data
  //           Map<dynamic, dynamic>? userDataMap =
  //               usersDataMap[userId] as Map<dynamic, dynamic>?;
  //           // Assuming userDataMap is a Map<String, dynamic> representing user data
  //           if (userDataMap != null) {
  //             userDataMap.forEach((id, data) {
  //               _userDataList.add(FoodBankData.fromJson(data));
  //             });
  //           }
  //         }
  //         setState(() {}); // Refresh the UI
  //       }
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _userDataSubscription?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Thank You!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('For Registering your Food Bank or Food NGO'),
                  Text(
                      'Our team will reachout you in few hours for further verification process & more info.'),
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
                                      text: 'Ngo Name: ', style: kTextStyleB),
                                  TextSpan(
                                      text: widget.ngoName, style: kTextStyleN),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Address: ', style: kTextStyleB),
                                  TextSpan(
                                      text: widget.address, style: kTextStyleN),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Contact: ', style: kTextStyleB),
                                  TextSpan(
                                      text: widget.phone, style: kTextStyleN),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Adress: ', style: kTextStyleB),
                                  TextSpan(
                                      text: widget.address, style: kTextStyleN),
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
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
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
                    builder: (context) => InitScreen(),
                  ),
                );
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text('Food bank will be notified when you click "confirm"'),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
