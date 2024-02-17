import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/screens/Add%20Location/addLocationDetails.dart';
import 'package:hunger/screens/FoodBank/addFoodBankDetails.dart';
import 'package:hunger/screens/addFood/addFoodDetails.dart';
import 'package:hunger/screens/intiScreen.dart';

import '../../components/socal_card.dart';
import '../../constants.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  final String buttonPressed;

  const SignUpScreen({Key? key, required this.buttonPressed}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ValueNotifier<UserCredential?> userCredential =
      ValueNotifier<UserCredential?>(null);
  bool _isLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Set the value of userCredential after successful authentication
      userCredential.value = userCred;
    } catch (e) {
      // Handle errors
      print('exception->$e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(
        showLogOut: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("Register Account", style: headingStyle),
                  const Text(
                    "Complete your details or continue \nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SignUpForm(
                    buttonPressed: widget.buttonPressed,
                  ),
                  const SizedBox(height: 16),
                  const Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Text("  OR  "),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SocalCard(
                              icon: "assets/icons/google-icon.svg",
                              press: () async {
                                await signInWithGoogle();
                                // Check if userCredential is not null after authentication
                                if (userCredential.value != null) {
                                  print(userCredential.value!.user!.email);
                                  switch (widget.buttonPressed) {
                                    case "Submit Remaining Food":
                                      Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const AddFoodDetails(),
                                        ),
                                      );
                                      break;
                                    case "Add more Locations":
                                      Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const AddLocationDetails(),
                                        ),
                                      );
                                      break;
                                    case "Register Food Center":
                                      Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const AddFoodBankDetails(),
                                        ),
                                      );
                                      break;
                                    case "Sign In":
                                      Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const InitScreen(),
                                        ),
                                      );
                                      break;
                                    default:
                                      // Navigate to a default screen if buttonPressed is not recognized
                                      break;
                                  }
                                }
                                print(widget.buttonPressed);
                              },
                            ),
                      // SocalCard(
                      //   icon: "assets/icons/facebook-2.svg",
                      //   press: () {},
                      // ),
                      // SocalCard(
                      //   icon: "assets/icons/twitter.svg",
                      //   press: () {},
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'By continuing your confirm that you agree \nwith our Term and Condition',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
