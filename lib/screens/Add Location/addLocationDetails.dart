import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/screens/Add%20Location/componets/LocationDetailsForm.dart';

class AddLocationDetails extends StatefulWidget {
  const AddLocationDetails({super.key});

  @override
  State<AddLocationDetails> createState() => _AddLocationDetailsState();
}

class _AddLocationDetailsState extends State<AddLocationDetails> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(
        showLogOut: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text(
                "Enter Location Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "you Have any location details?  \nThen fill this form and submit the details",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              AddLocationDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
