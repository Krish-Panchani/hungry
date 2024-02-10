import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/intiScreen.dart';

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
            title: const Text('About'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const HomeScreen(),
              //   ),
              // );
            },
          ),
          ListTile(
            title: const Text('Contact'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const HomeScreen(),
              //   ),
              // );
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
        ],
      ),
    );
  }
}
