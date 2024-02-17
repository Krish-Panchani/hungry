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

import '../../components/no_account_text.dart';
import '../../components/socal_card.dart';
import 'components/sign_form.dart';

class SignInScreen extends StatefulWidget {
  final String buttonPressed;

  const SignInScreen({Key? key, required this.buttonPressed}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final ValueNotifier<UserCredential?> userCredential =
      ValueNotifier<UserCredential?>(null);
  bool _isLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw Exception('Failed to sign in with Google.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      this.userCredential.value = userCredential;
    } catch (e) {
      // Handle error
      print('Exception during Google sign in: $e');
      userCredential.value = null;
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
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Sign in with your email and password\nor continue with social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SignForm(buttonPressed: widget.buttonPressed),
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
                                    case "Login":
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  const NoAccountText(
                    buttonPressed: 'Sign In',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
