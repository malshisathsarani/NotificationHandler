import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define your messages
List<Map<String, String>> messages = [
  {'title': 'Reminder 1', 'body': 'This is the first reminder.'},
  {'title': 'Reminder 2', 'body': 'This is the second reminder.'},
  {'title': 'Reminder 3', 'body': 'This is the third reminder.'},
  // Add more messages as needed
];

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize notifications
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          icon: 'resource://drawable/res_notification_icon',
        ),
      ],
    );

    // Call the function to create a notification
    await createNotification();

    return Future.value(true);
  });
}

Future<void> createNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int messageIndex = (prefs.getInt('messageIndex') ?? 0) % messages.length;
  Map<String, String> message = messages[messageIndex];

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10, // Unique ID for the notification
      channelKey: 'basic_channel', // Channel key to which this notification belongs
      title: message['title'], // Dynamic title
      body: message['body'], // Dynamic body text
    ),
  );

  prefs.setInt('messageIndex', messageIndex + 1);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon', // Your app icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        icon: 'resource://drawable/res_notification_icon', // Correctly named small icon
      ),
    ],
  );

  // Initialize Workmanager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Schedule a periodic task to run every 15 minutes
  Workmanager().registerPeriodicTask(
    '15minTask',
    'simplePeriodicTask',
    frequency: const Duration(minutes: 15),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Awesome Notifications')), // App bar with title
        body: const Center(
          child: Text('Notifications will be sent every 15 minutes'), // Info text
        ),
      ),
    );
  }
}
