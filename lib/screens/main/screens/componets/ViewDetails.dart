import 'package:flutter/material.dart';
import 'package:hunger/Provider/UserDataProvider.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:provider/provider.dart';

class ViewDetailsScreen extends StatefulWidget {
  const ViewDetailsScreen({super.key});

  @override
  State<ViewDetailsScreen> createState() => _ViewDetailsScreenState();
}

class _ViewDetailsScreenState extends State<ViewDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final userData = userDataProvider.selectedUserData!;
    return Scaffold(
      appBar: MyAppBar(),
      drawer: const MyDrawer(
        showLogOut: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${userData.fname}'),
            Text('Address: ${userData.address}'),
            // Add other details as needed
          ],
        ),
      ),
    );
  }
}
