import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/screens/addFood/componets/FoodDetailsForm.dart';

class AddFoodDetails extends StatefulWidget {
  const AddFoodDetails({super.key});

  @override
  State<AddFoodDetails> createState() => _AddFoodDetailsState();
}

class _AddFoodDetailsState extends State<AddFoodDetails> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text(
                "Enter Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "If you Have ramainig food..?  \nThen fill this form and submit the details",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              AddFoodDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
