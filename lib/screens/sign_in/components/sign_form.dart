import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hunger/screens/Add%20Location/LocationDetails.dart';
import 'package:hunger/screens/Add%20Location/addLocationDetails.dart';
import 'package:hunger/screens/FoodBank/FoodBankDetails.dart';
import 'package:hunger/screens/FoodBank/addFoodBankDetails.dart';
import 'package:hunger/screens/addFood/FoodDetailsScreen.dart';

import 'package:hunger/screens/addFood/addFoodDetails.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class SignForm extends StatefulWidget {
  final String buttonPressed;
  const SignForm({
    Key? key,
    required this.buttonPressed,
  }) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Added for tracking loading state

  void login() async {
    setState(() {
      isLoading = true; // Set loading state to true while authenticating
    });
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      log("Please fill all the fields!");
      setState(() {
        isLoading = false; // Set loading state to false if validation fails
      });
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          if (widget.buttonPressed == "Submit Remaining Food") {
            var userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .get();
            if (userDoc.exists) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const FoodDetailsScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const AddFoodDetails(),
                ),
              );
            }
          } else if (widget.buttonPressed == "Add more Locations") {
            var locDoc = await FirebaseFirestore.instance
                .collection('locations')
                .doc(userCredential.user!.uid)
                .get();
            if (locDoc.exists) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const LocationDetailsScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const AddLocationDetails(),
                ),
              );
            }
          } else if (widget.buttonPressed == "Register Food Center") {
            var locDoc = await FirebaseFirestore.instance
                .collection('locations')
                .doc(userCredential.user!.uid)
                .get();
            if (locDoc.exists) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const FoodBankDetailsScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const AddFoodBankDetails(),
                ),
              );
            }
          }
          print(widget.buttonPressed.toString());
        }
      } on FirebaseAuthException catch (e) {
        log(e.code.toString());
      } finally {
        setState(() {
          isLoading =
              false; // Set loading state to false after authentication completes
        });
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

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
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              elevation: 1.0,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                login();
              }
            },
            child: isLoading
                ? const CircularProgressIndicator() // Show loading indicator if isLoading is true
                : const Text(
                    "Sign In",
                    style: TextStyle(color: kTextColor),
                  ),
          ),
        ],
      ),
    );
  }
}
