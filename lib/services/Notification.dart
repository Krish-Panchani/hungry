import 'package:firebase_messaging/firebase_messaging.dart';

class MyFirebaseMessagingService {
  void onMessageReceived(RemoteMessage message) {
    // super.onMessageReceived(message);

    // Handle FCM messages here
    print('Received message: ${message.notification!.title}');
    print('Received message body: ${message.notification!.body}');

    // You can also access data sent with the notification
    if (message.data.isNotEmpty) {
      print('Message data payload: ${message.data}');

      // Access specific data fields
      final String? fname = message.data['Fname'];
      final String? address = message.data['address'];

      // Handle the notification data
      if (fname != null && address != null) {
        // Display notification to the user
        _showNotification(
            message.notification!.title!, message.notification!.body!);

        // Handle additional logic based on notification data
        _handleNotificationData(fname, address);
      }
    }
  }

  void _showNotification(String title, String body) {
    // Implement code to display notifications in your app
    // You can use packages like flutter_local_notifications to handle notifications
  }

  void _handleNotificationData(String fname, String address) {
    // Implement code to handle notification data
    print('Notification Data - fname: $fname, address: $address');
    // You can navigate to specific screens, update UI, etc. based on the notification data
  }
}
