import 'package:firebase_messaging/firebase_messaging.dart';

class MyFirebaseMessagingService {
  void onMessageReceived(RemoteMessage message) {
    print('Received message: ${message.notification!.title}');
    print('Received message body: ${message.notification!.body}');

    if (message.data.isNotEmpty) {
      print('Message data payload: ${message.data}');

      final String? fname = message.data['Fname'];
      final String? address = message.data['address'];

      if (fname != null && address != null) {
        _showNotification(
            message.notification!.title!, message.notification!.body!);

        _handleNotificationData(fname, address);
      }
    }
  }

  void _showNotification(String title, String body) {}

  void _handleNotificationData(String fname, String address) {
    print('Notification Data - fname: $fname, address: $address');
  }
}
