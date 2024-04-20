import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';

class HelpCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: Center(
        child: Text('Help Center Screen'),
      ),
    );
  }
}
