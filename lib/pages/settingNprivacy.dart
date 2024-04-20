import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';

class SettingsPrivacyScreen extends StatefulWidget {
  @override
  _SettingsPrivacyScreenState createState() => _SettingsPrivacyScreenState();
}

class _SettingsPrivacyScreenState extends State<SettingsPrivacyScreen> {
  bool _notificationEnabled = true; // Example value, replace with actual value
  bool _darkModeEnabled = false; // Example value, replace with actual value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: ListView(
        children: [
          ListTile(
            title: Text('Notification Settings'),
            subtitle: Text('Turn on/off notifications'),
            trailing: Switch(
              activeColor: kSecondaryColor,
              
              value: _notificationEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationEnabled = value;
                  // Implement logic to update notification settings
                });
              },
            ),
            onTap: () {
              setState(() {
                _notificationEnabled = !_notificationEnabled;
                // Implement logic to update notification settings
              });
            },
          ),
          ListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Enable/disable dark mode'),
            trailing: Switch(
              activeColor: kSecondaryColor,
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                  // Implement logic to toggle dark mode
                });
              },
            ),
            onTap: () {
              setState(() {
                _darkModeEnabled = !_darkModeEnabled;
                // Implement logic to toggle dark mode
              });
            },
          ),
          // Additional settings options
          ListTile(
            title: Text('Language'),
            subtitle: Text('Change app language'),
            onTap: () {
              // Implement logic to change app language
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            subtitle: Text('View our privacy policy'),
            onTap: () {
              // Implement logic to navigate to privacy policy screen
            },
          ),
          ListTile(
            title: Text('Terms of Service'),
            subtitle: Text('View our terms of service'),
            onTap: () {
              // Implement logic to navigate to terms of service screen
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
