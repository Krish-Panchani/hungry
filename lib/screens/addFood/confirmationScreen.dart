import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/intiScreen.dart';

class FoodConfirmationDetails extends StatefulWidget {
  final String firstName;
  final String phoneNumber;
  final String address;
  final String details;
  final LatLng location;
  final String id;

  const FoodConfirmationDetails({
    Key? key,
    required this.firstName,
    required this.phoneNumber,
    required this.address,
    required this.details,
    required this.location,
    required this.id,
  }) : super(key: key);

  @override
  State<FoodConfirmationDetails> createState() =>
      _FoodConfirmationDetailsState();
}

class _FoodConfirmationDetailsState extends State<FoodConfirmationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
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
                    'For your small Help',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Your details is notified to nearby Food Banks, and will'),
                  Text('Contact you soon as possible'),
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
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Details: ', style: kTextStyleB),
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
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nearest Food Bank',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                        size: 40,
                        color: kPrimaryColor,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Name: ', style: kTextStyleB),
                                TextSpan(
                                    text: 'AHM FoodBank', style: kTextStyleN),
                              ],
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
                            child: const Text(
                              '2 km',
                              style: TextStyle(
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
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Address: ', style: kTextStyleB),
                                TextSpan(
                                    text: 'Ahmedabad, Gujrat',
                                    style: kTextStyleN),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Contact: ', style: kTextStyleB),
                                TextSpan(
                                    text: '9867345262', style: kTextStyleN),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Get Direction',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                    builder: (context) => const InitScreen(),
                  ),
                );
              },
              child: const Text(
                'Back to Home',
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
    );
  }
}
