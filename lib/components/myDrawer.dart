import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/pages/AboutUs.dart';
import 'package:hunger/pages/ContactUs.dart';
import 'package:hunger/screens/intiScreen.dart';
import 'package:hunger/screens/sign_in/sign_in_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  final bool showLogOut;

  const MyDrawer({Key? key, required this.showLogOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (user != null && user.photoURL != null)
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                if (user == null || user.photoURL == null)
                  const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 50,
                  ),
                const SizedBox(height: 10),
                Text(
                  user != null ? user.displayName ?? 'User' : 'Guest',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user != null ? user.email ?? 'User' : 'Guest',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
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
            leading: const Icon(Icons.info_outline),
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
            leading: const Icon(Icons.contact_page_outlined),
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
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Feedback'),
            onTap: () {
              _launchFeedbackForm();
            },
          ),
          if (showLogOut) // Conditionally show the LogOut list tile
            if (FirebaseAuth.instance.currentUser != null)
              // User is logged in
              ListTile(
                leading: const Icon(Icons.logout),
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
              leading: const Icon(Icons.login),
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
          DrawerExpansionTile(
            title: 'Settings & Support',
            children: [
              DrawerTile(
                icon: Icons.settings,
                title: 'Settings & Privacy',
                onTap: () {
                  // Handle onTap for Settings & Privacy
                },
              ),
              DrawerTile(
                icon: Icons.help,
                title: 'Help Center',
                onTap: () {
                  // Handle onTap for Help Center
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Add some spacing
          const Divider(), // Add a divider
          Text(
            'Hungry',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _launchFeedbackForm() async {
    const url =
        'https://docs.google.com/forms/d/e/1FAIpQLScwD_Bbj022AZa53E2GLj6njmveK0p4nqBXO_r9eaZYg6eVHQ/viewform';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}

class DrawerExpansionTile extends StatelessWidget {
  final String title;
  final List<DrawerTile> children;

  const DrawerExpansionTile({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
      ),
      children: children,
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
