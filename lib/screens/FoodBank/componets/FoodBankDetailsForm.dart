import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hunger/components/customElevatedButton.dart';
import 'package:hunger/components/customTextField.dart';
import 'package:hunger/screens/FoodBank/componets/BasicQAForm.dart';
import 'package:hunger/screens/FoodBank/mapScreen3.dart';
import 'package:hunger/services/Notification.dart';
import 'package:uuid/uuid.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class AddFoodBankDetailsForm extends StatefulWidget {
  const AddFoodBankDetailsForm({super.key});

  @override
  State<AddFoodBankDetailsForm> createState() => _AddFoodBankDetailsFormState();
}

class _AddFoodBankDetailsFormState extends State<AddFoodBankDetailsForm> {
  NotificationServices notificationServices = NotificationServices();
  TextEditingController FoodNGoNameController = TextEditingController();
  TextEditingController FnameController = TextEditingController();
  TextEditingController GmailController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController VolunteersController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  LatLng? selectedLocation;

  String? userId;

  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? FoodNgoName;
  String? firstName;
  String? Gmail;
  String? phoneNumber;
  String? Volunteers;
  String? address;

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
            controller: FoodNGoNameController,
            labelText: "Food Bank or NGO Name",
            hintText: "Enter Food bank or NGO name",
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
            controller: FnameController,
            labelText: "Name of Head Person",
            hintText: "Enter Name of head person",
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
            controller: GmailController,
            labelText: "Gmail",
            hintText: "Enter your gmail",
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
            controller: VolunteersController,
            labelText: "No. of Volunteers",
            hintText: "Enter no. of volunteers",
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
            controller: addressController,
            labelText: "Address",
            hintText: "Enter your Address",
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
                    builder: (context) => MapScreen3(
                      firstName: FnameController.text.trim(),
                      phoneNumber: PhoneController.text.trim(),
                      address: addressController.text.trim(),
                      foodNgoName: FoodNGoNameController.text.trim(),
                    ),
                  ),
                );

                // If a location is selected on the map screen, save the data to Firestore
                if (location != null) {
                  saveDataToRealtimeDatabase(location);
                  notificationServices.getDeviceToken().then((value) {
                    if (kDebugMode) {
                      print('device token');
                      print(value);
                    }
                    FirebaseAuth auth = FirebaseAuth.instance;
                    String? authUserId = auth.currentUser?.uid;
                    if (userId == null) {
                      return // Store the device token in Firestore
                          FirebaseFirestore.instance
                              .collection('tokens')
                              .doc(authUserId)
                              .set({'token': value}).then((_) {
                        print('Device token stored in Firestore');
                      }).catchError((error) {
                        print('Failed to store device token: $error');
                      });
                    }
                  });
                }
              }
            },
            text: "Select Location",
          ),
        ],
      ),
    );
  }

  void _navigateToMapScreen() async {
    setState(() {
      _isLoading = true;
    });

    LatLng? location = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen3(
          foodNgoName: FoodNGoNameController.text.trim(),
          firstName: FnameController.text.trim(),
          phoneNumber: PhoneController.text.trim(),
          address: addressController.text.trim(),
        ),
      ),
    );

    if (location != null) {
      saveDataToRealtimeDatabase(location);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void saveDataToRealtimeDatabase(LatLng location) async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not authenticated");
      }

      String userId = user.uid;
      String FoodNgoName = FoodNGoNameController.text.trim();
      String Fname = FnameController.text.trim();
      String Gmail = GmailController.text.trim();
      String phone = PhoneController.text.trim();
      String noVolunteers = VolunteersController.text.trim();
      String address = addressController.text.trim();
      String selectedLocationString =
          "${location.latitude},${location.longitude}";

      String id = const Uuid().v4();

      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

      await databaseReference.child('FoodBanks').child(userId).child(id).set({
        "FoodNgoName": Fname,
        "Fname": FoodNgoName,
        "gmail": Gmail,
        "phone": phone,
        "volunteers": noVolunteers,
        "address": address,
        "location": selectedLocationString,
      });

      log("Food Bank data saved to Realtime Database");

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => BasicQAForm(
            nogName: FoodNGoNameController.text.trim(),
            address: addressController.text.trim(),
            phone: PhoneController.text.trim(),
            firstName: FnameController.text.trim(),
          ),
        ),
      );
    } catch (error) {
      print("Error saving data: $error");
      // Handle error appropriately, show error message to the user, etc.
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
