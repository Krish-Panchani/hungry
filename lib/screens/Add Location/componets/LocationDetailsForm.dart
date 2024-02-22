import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hunger/components/customElevatedButton.dart';
import 'package:hunger/components/customTextField.dart';
import 'package:hunger/screens/Add%20Location/LocationConfirmation.dart';
import 'package:hunger/screens/Add%20Location/LocationDetails.dart';
import 'package:hunger/screens/Add%20Location/mapScreen2.dart';
import 'package:uuid/uuid.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class AddLocationDetailsForm extends StatefulWidget {
  const AddLocationDetailsForm({Key? key}) : super(key: key);

  @override
  State<AddLocationDetailsForm> createState() => _AddLocationDetailsFormState();
}

class _AddLocationDetailsFormState extends State<AddLocationDetailsForm> {
  TextEditingController FnameController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController detialsController = TextEditingController();
  LatLng? selectedLocation;

  String? userId;

  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? phoneNumber;
  String? address;
  String? details;

  bool _isLoading = false;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: FnameController,
            labelText: "Location Name",
            hintText: "Enter your Location name",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              }
            },
            errorText:
                errors.contains(kNamelNullError) ? kNamelNullError : null,
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return kNamelNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: PhoneController,
            labelText: "Phone Number",
            hintText: "Enter your phone number",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            errorText: errors.contains(kPhoneNumberNullError)
                ? kPhoneNumberNullError
                : null,
            onSaved: (newValue) => phoneNumber = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPhoneNumberNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return kPhoneNumberNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: addressController,
            labelText: "Location Address",
            hintText: "Enter your Location Address",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/Location point.svg"),
            errorText:
                errors.contains(kAddressNullError) ? kAddressNullError : null,
            onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kAddressNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kAddressNullError);
                return kAddressNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: detialsController,
            maxLines: 3,
            labelText: "Details",
            hintText: "Enter your Details",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/Location point.svg"),
            errorText:
                errors.contains(kDetailsNullError) ? kDetailsNullError : null,
            onSaved: (newValue) => details = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kDetailsNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kDetailsNullError);
                return kDetailsNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          FormError(errors: errors),
          const SizedBox(height: 50),
          CustomElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Save the form data
                _formKey.currentState!.save();

                // Navigate to the map screen to select a location
                LatLng? location = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen2(
                      firstName: FnameController.text.trim(),
                      phoneNumber: PhoneController.text.trim(),
                      address: addressController.text.trim(),
                      details: detialsController.text.trim(),
                    ),
                  ),
                );

                // If a location is selected on the map screen, save the data to Firestore
                if (location != null) {
                  saveDataAndNavigate(location);
                }
              }
            },
            text: "Select Location",
          ),
        ],
      ),
    );
  }

  void _openMapToSelectLocation() async {
    // Navigate to map screen where user can select location
    LatLng? location = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen2(
          firstName: '',
          phoneNumber: '',
          details: '',
          address: '',
        ),
      ),
    );

    if (location != null) {
      setState(() {
        selectedLocation = location;
      });
    }
  }

  Future<void> saveDataAndNavigate(LatLng location) async {
    try {
      // Save data to Firebase
      String id = const Uuid().v4();
      await saveDataToRealtimeDatabase(location, id);

      // Navigate to next screen with all the data
      navigateToConfirmationScreen(location, id);
    } catch (error) {
      // Handle error
      print("Error saving data: $error");
    }
  }

  Future<void> saveDataToRealtimeDatabase(LatLng location, String id) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;
      String Fname = FnameController.text.trim();
      String phone = PhoneController.text.trim();
      String address = addressController.text.trim();
      String details = detialsController.text.trim();
      String selectedLocationString =
          "${location.latitude},${location.longitude}";

      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

      await databaseReference.child('locations').child(userId).child(id).set({
        "Fname": Fname,
        "phone": phone,
        "address": address,
        "details": details,
        "location": selectedLocationString,
      });

      log("User data saved to Realtime Database");
    }
  }

  void navigateToConfirmationScreen(LatLng location, String id) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => LocatinConfirmScreen(
          firstName: FnameController.text.trim(),
          phoneNumber: PhoneController.text.trim(),
          address: addressController.text.trim(),
          details: detialsController.text.trim(),
          location: location,
          id: id,
        ),
      ),
    );
  }
}
