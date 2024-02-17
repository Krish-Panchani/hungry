import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/pages/AboutUs.dart';
import 'package:hunger/pages/ContactUs.dart';
import 'package:hunger/screens/intiScreen.dart';
import 'package:hunger/screens/sign_in/sign_in_screen.dart';

class MyDrawer extends StatelessWidget {
  final bool showLogOut;

  const MyDrawer({Key? key, required this.showLogOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InitScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Contact'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactUsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Feedback'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const HomeScreen(),
              //   ),
              // );
            },
          ),
          if (showLogOut) // Conditionally show the LogOut list tile
            if (FirebaseAuth.instance.currentUser != null)
              // User is logged in
              ListTile(
                title: const Text('LogOut'),
                onTap: () {
                  // Sign out the user
                  FirebaseAuth.instance.signOut();

                  // Navigate to InitScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InitScreen(),
                    ),
                  );
                },
              ),
          // User is not logged in
          if (FirebaseAuth.instance.currentUser == null)
            ListTile(
              title: const Text('Login'),
              onTap: () {
                // Navigate to SignInScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(
                      buttonPressed: 'Login',
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 20), // Add some spacing
          const Divider(), // Add a divider
          const ListTile(
            title: Text(
              'Version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
