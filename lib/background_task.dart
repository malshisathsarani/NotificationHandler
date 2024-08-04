import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10, // Unique ID for the notification
      channelKey: 'basic_channel', // Channel key to which this notification belongs
      title: 'Reminder', // Title of the notification
      body: 'This is a reminder notification.', // Body text of the notification
    ),
  );
}
