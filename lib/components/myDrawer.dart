import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/intiScreen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
