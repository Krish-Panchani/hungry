import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/customElevatedButton.dart';
import 'package:hunger/components/customTextField.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/FoodBank/FoodBankDetails.dart';

class BasicQAForm extends StatefulWidget {
  const BasicQAForm({super.key});

  @override
  State<BasicQAForm> createState() => _BasicQAFormState();
}

class _BasicQAFormState extends State<BasicQAForm> {
  TextEditingController minPeopleAcceptedController = TextEditingController();
  bool acceptingRemainingFood = false;
  bool distributingToNeedyPerson = false;
  bool freeMealAvailable = false;
  bool acceptingDonations = false;
  bool acceptTermsAndConditions = false;
  int minPeopleAccepted = 0;

  void submitForm() {
    // Validate and submit the form data to Firebase backend
    if (!acceptTermsAndConditions) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content:
              Text('Please accept the Terms & Conditions to submit the form.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Save form data to Firestore
    FirebaseFirestore.instance.collection('food_donation_forms').add({
      'acceptingRemainingFood': acceptingRemainingFood,
      'minPeopleAccepted': minPeopleAccepted,
      'distributingToNeedyPerson': distributingToNeedyPerson,
      'freeMealAvailable': freeMealAvailable,
      'acceptingDonations': acceptingDonations,
    }).then((value) {
      log('Form submitted successfully.');
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const FoodBankDetailsScreen(),
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Q/A',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text('1. Are you accepting Remaining Food?'),
                value: acceptingRemainingFood,
                onChanged: (value) {
                  setState(() {
                    acceptingRemainingFood = value!;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              if (acceptingRemainingFood) ...[
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomTextField(
                    controller: minPeopleAcceptedController,
                    labelText: 'Minimum People Accepted',
                    hintText: 'Enter the minimum number of people',
                    suffixIcon: Icon(Icons.people),
                  ),
                ),
                SizedBox(height: 10),
              ],
              CheckboxListTile(
                title: Text(
                    '2. Are you distributing food to any hungry Needy Person?'),
                value: distributingToNeedyPerson,
                onChanged: (value) {
                  setState(() {
                    distributingToNeedyPerson = value!;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              if (!distributingToNeedyPerson) ...[
                CheckboxListTile(
                  title: Text(
                      'If a hungry person locates you and comes to your center, can you give them a free meal?'),
                  value: freeMealAvailable,
                  onChanged: (value) {
                    setState(() {
                      freeMealAvailable = value!;
                    });
                  },
                  activeColor: kPrimaryColor,
                ),
              ],
              CheckboxListTile(
                title: Text('3. Are you accepting Donations?'),
                value: acceptingDonations,
                onChanged: (value) {
                  setState(() {
                    acceptingDonations = value!;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: acceptTermsAndConditions,
                    onChanged: (value) {
                      setState(() {
                        acceptTermsAndConditions = value!;
                      });
                    },
                    activeColor: kPrimaryColor,
                  ),
                  Expanded(
                    child: Text(
                      'Accept the Terms & Conditions and Privacy Policy of Hungry (India).',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                  child: CustomElevatedButton(
                      onPressed: () => submitForm(), text: 'Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
