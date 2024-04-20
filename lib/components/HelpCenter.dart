import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/customElevatedButton.dart';
import 'package:hunger/components/myDrawer.dart';

class HelpCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Help Center',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CustomElevatedButton(onPressed: () {}, text: 'FAQ'),
            SizedBox(height: 10),
            CustomElevatedButton(onPressed: () {}, text: 'Contact Support'),
            SizedBox(height: 10),
            CustomElevatedButton(onPressed: () {}, text: 'Lice Chat'),
            SizedBox(height: 10),
            CustomElevatedButton(onPressed: () {}, text: 'Report a Problem'),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
