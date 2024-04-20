import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';

class SettingsPrivacyScreen extends StatelessWidget {
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
              value: true, // Replace with actual value
              onChanged: (value) {
                // Implement logic to update notification settings
              },
            ),
          ),
          ListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Enable/disable dark mode'),
            trailing: Switch(
              value: true, // Replace with actual value
              onChanged: (value) {
                // Implement logic to toggle dark mode
              },
            ),
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
