import 'package:atom/app/app.dart';
import 'package:atom/bootstrap.dart';
import 'package:atom/packages/supabase_client/supabase_client.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'packages/user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Remove this method to stop OneSignal Debugging
  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  await OneSignal.shared.setAppId('91c3fd9f-b02c-4b09-a1ae-eeb36769841b');

  // The promptForPushNotificationsWithUserResponse function
  // will show the iOS or Android push notification prompt.
  // We recommend removing the following code and instead
  // using an In-App Message to prompt for notification permission
  await OneSignal.shared.getDeviceState();
  // print('id: ${status?.userId}');
  await OneSignal.shared
      .promptUserForPushNotificationPermission()
      .then((accepted) {
    // print('Accepted permission: $accepted');
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });

  await bootstrap(() {
    const url = 'https://wxewqtcnxxcrtiruydky.supabase.co';
    const key =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind4ZXdxdGNueHhjcnRpcnV5ZGt5Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY4MzIwMTUzMywiZXhwIjoxOTk4Nzc3NTMzfQ.RHmLq5dWkPSLnC5O7FZ-xcF1Y14mmX5qjCj2j4NBHic';
    final databaseClient = DatabaseClient(url: url, key: key);
    final userRepository = UserRepository(databaseClient: databaseClient);
    return App(userRepository: userRepository);
  });
}
