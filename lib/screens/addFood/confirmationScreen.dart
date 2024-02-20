import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';

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
      body: Column(
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
                Text('Your details is notified to nearby Food Banks, and will'),
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${widget.firstName}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Phone : ${widget.phoneNumber}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Details: ${widget.details}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
