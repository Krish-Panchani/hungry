import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/models/UserModal.dart';

class ViewDetailsScreen extends StatefulWidget {
  final UserData userData;
  const ViewDetailsScreen({super.key, required this.userData});

  @override
  State<ViewDetailsScreen> createState() => _ViewDetailsScreenState();
}

class _ViewDetailsScreenState extends State<ViewDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: const MyDrawer(
        showLogOut: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Name: ${widget.userData.fname}'),
            Text('Address: ${widget.userData.address}'),
            // Display other details as needed
          ],
        ),
      ),
    );
  }
}
