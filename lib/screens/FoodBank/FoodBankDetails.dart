import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/models/FoodBankModal.dart';
import 'package:hunger/screens/FoodBank/addFoodBankDetails.dart';

class FoodBankDetailsScreen extends StatefulWidget {
  const FoodBankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<FoodBankDetailsScreen> createState() => FoodBankDetailsScreenState();
}

class FoodBankDetailsScreenState extends State<FoodBankDetailsScreen> {
  late DatabaseReference _databaseRef;

  StreamSubscription<dynamic>? _userDataSubscription;
  final List<FoodBankData> _userDataList = [];

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.ref().child('FoodBanks');
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
                _userDataList.add(FoodBankData.fromJson(data));
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
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                    text: 'FoodBank Name: ',
                                    style: kTextStyleB),
                                TextSpan(
                                    text: userData.FoodNgoName,
                                    style: kTextStyleN),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                    text: 'Name: ', style: kTextStyleB),
                                TextSpan(
                                    text: userData.Head, style: kTextStyleN),
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
                                    text: userData.address, style: kTextStyleN),
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
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                    text: 'Volunteers: ', style: kTextStyleB),
                                TextSpan(
                                    text: userData.NumberOfPersons,
                                    style: kTextStyleN),
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
              builder: (context) => const AddFoodBankDetails(),
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
