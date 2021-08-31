import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String token = '';
  String get pushToken => token;
  void initializePushNotificationService() async {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      if (value != null) {
        token = value;
        print('Notifcation Token: $value');
      }
    });
  }

  Future<String> getPushNotificationToken() async {
    String token = '';
    await messaging.getToken().then((value) {
      if (value != null) {
        token = value;
      }
    });
    return token;
  }
}
