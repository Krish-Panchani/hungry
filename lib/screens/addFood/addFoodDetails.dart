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
      drawer: MyDrawer(
        showLogOut: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text(
                "Submit Leftover Food",
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
                "Your small help let our App one step\nclose to kill hungers",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              AddFoodDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
