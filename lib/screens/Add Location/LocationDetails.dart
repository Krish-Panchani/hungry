import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/models/UserModal.dart';
import 'package:hunger/screens/Add%20Location/addLocationDetails.dart';

class LocationDetailsScreen extends StatefulWidget {
  const LocationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<LocationDetailsScreen> createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  late DatabaseReference _databaseRef;

  StreamSubscription<dynamic>? _userDataSubscription;
  final List<UserData> _userDataList = [];

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.ref().child('locations');
    _userDataSubscription = _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _userDataList.clear();
        // Get the current user's ID
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          // Assuming event.snapshot.value is a Map<String, dynamic>
          Map<dynamic, dynamic>? usersDataMap = event.snapshot.value as Map?;
          // Check if the current user's data exists in the snapshot
          if (usersDataMap != null && usersDataMap.containsKey(userId)) {
            // Retrieve the current user's data
            Map<dynamic, dynamic>? userDataMap =
                usersDataMap[userId] as Map<dynamic, dynamic>?;
            // Assuming userDataMap is a Map<String, dynamic> representing user data
            if (userDataMap != null) {
              userDataMap.forEach((id, data) {
                _userDataList.add(UserData.fromJson(data));
              });
            }
          }
          setState(() {}); // Refresh the UI
        }
      }
    });
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(
        showLogOut: true,
      ),
      body: _userDataList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Show a loading indicator while data is being fetched
          : SingleChildScrollView(
              child: Column(
                children: _userDataList.map((userData) {
                  return ListTile(
                    title: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor, width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                    text: 'Location Name: ',
                                    style: kTextStyleB),
                                TextSpan(
                                    text: userData.fname, style: kTextStyleN),
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
                                    text: userData.address, style: kTextStyleN),
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
                                    text: userData.details, style: kTextStyleN),
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
                                    text: userData.phone, style: kTextStyleN),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed action here
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const AddLocationDetails(),
            ),
          );
        },
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
