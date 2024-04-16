import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/addFood/componets/NearbyFoodBank.dart';
import 'package:hunger/screens/addFood/thankYouScreen.dart';
import 'package:hunger/services/Notification.dart';
import 'package:http/http.dart' as http;

class FoodConfirmationDetails extends StatefulWidget {
  final String firstName;
  final String phoneNumber;
  final String address;
  final String details;
  final String persons;
  final LatLng location;
  final String id;

  const FoodConfirmationDetails({
    Key? key,
    required this.firstName,
    required this.phoneNumber,
    required this.address,
    required this.details,
    required this.persons,
    required this.location,
    required this.id,
  }) : super(key: key);

  @override
  State<FoodConfirmationDetails> createState() =>
      _FoodConfirmationDetailsState();
}

class _FoodConfirmationDetailsState extends State<FoodConfirmationDetails> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
  }

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
                    'Confirm???',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Your small help let our App one step close to'),
                  Text('kill the Hunger'),
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
                                      text: 'Name: ', style: kTextStyleB),
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
                                      text: 'Persons: ', style: kTextStyleB),
                                  TextSpan(
                                      text: widget.persons, style: kTextStyleN),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Food Details: ',
                                      style: kTextStyleB),
                                  TextSpan(
                                      text: widget.details, style: kTextStyleN),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            NearbyFoodBanks(),
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
                    builder: (context) => ThankYouScreen(
                      firstName: widget.firstName,
                      phoneNumber: widget.phoneNumber,
                      address: widget.address,
                      details: widget.details,
                      persons: widget.persons,
                      location: widget.location,
                      id: widget.id,
                    ),
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

  void sendNotification() {
    FirebaseFirestore.instance
        .collection('tokens')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String token = (doc.data() as Map<String, dynamic>)['token'];
        sendNotificationToToken(token);
      });
    }).catchError((error) {
      print("Error retrieving tokens: $error");
    });
  }

  void sendNotificationToToken(String token) async {
    var data = {
      'to': token,
      'notification': {
        'title': widget.firstName,
        'body': widget.address,
        // "sound": "jetsons_doorbell.mp3"
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
      'data': {'type': 'msg', 'id': '1234'}
    };

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAAzJx4c-0:APA91bF-ZSj7RHik48bjCkpeGQPFQizEgBTIHHxlsFp-aFV28bT5TzKP1P06YBzgDIlNsrlaUTrxWTuxonbGsqi05cglNN1BgIKcF2hjPiv1uMyyu6ZluM1A2xoYg-KSTClA_mdm-Cdm'
      },
    ).then((value) {
      if (kDebugMode) {
        print(value.body.toString());
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
