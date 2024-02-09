import 'package:flutter/material.dart';
import 'package:hunger/screens/sign_in/sign_in_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(buttonPressed: '',),
    );
  }
}
