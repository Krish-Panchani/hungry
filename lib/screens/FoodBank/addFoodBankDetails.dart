import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/screens/FoodBank/componets/FoodBankDetailsForm.dart';
import 'package:hunger/services/Notification.dart';

class AddFoodBankDetails extends StatefulWidget {
  const AddFoodBankDetails({super.key});

  @override
  State<AddFoodBankDetails> createState() => _AddFoodBankDetailsState();
}

class _AddFoodBankDetailsState extends State<AddFoodBankDetails> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(
        showLogOut: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text(
                "Enter Food Bank Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "you Have any Food Bank details?  \nThen fill this form and submit the details",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              AddFoodBankDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
