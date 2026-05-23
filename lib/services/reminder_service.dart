import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine_reminder_model.dart';

class ReminderService extends ChangeNotifier {
  static final ReminderService _instance = ReminderService._internal();
  factory ReminderService() => _instance;
  ReminderService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<MedicineReminderModel> _reminders = [];
  List<MedicineReminderModel> get reminders => _reminders;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    try {
      if (!kIsWeb) {
        await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: (details) {
            debugPrint("Notification clicked: ${details.payload}");
          },
        );
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint("Local notifications initialization error: $e");
    }

    await loadReminders();
  }

  Future<void> loadReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? remindersJson = prefs.getString('medicine_reminders');
      if (remindersJson != null) {
        final List<dynamic> decoded = jsonDecode(remindersJson);
        _reminders = decoded.map((item) => MedicineReminderModel.fromJson(item)).toList();
      } else {
        // Add some dummy reminders to look rich and beautiful on first open
        _reminders = [
          MedicineReminderModel(
            id: '1',
            medicineName: 'Paracetamol',
            dosage: '500mg (1 tablet)',
            time: '08:00 AM',
            frequency: 'Morning Only',
            status: 'Taken',
            notes: 'Take after breakfast',
          ),
          MedicineReminderModel(
            id: '2',
            medicineName: 'Amoxicillin',
            dosage: '250mg (1 capsule)',
            time: '02:00 PM',
            frequency: 'Afternoon Only',
            status: 'Pending',
            notes: 'Complete full course',
          ),
          MedicineReminderModel(
            id: '3',
            medicineName: 'Atorvastatin',
            dosage: '10mg (1 tablet)',
            time: '09:00 PM',
            frequency: 'Night Only',
            status: 'Missed',
            notes: 'Take before sleeping',
          ),
        ];
        await saveReminders();
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading reminders: $e");
    }
  }

  Future<void> saveReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('medicine_reminders', jsonEncode(_reminders.map((e) => e.toJson()).toList()));
    } catch (e) {
      debugPrint("Error saving reminders: $e");
    }
  }

  Future<void> addReminder(MedicineReminderModel reminder) async {
    _reminders.add(reminder);
    await saveReminders();
    notifyListeners();
    
    // Trigger notification when reminder is added successfully
    await triggerReminderNotification(reminder);
  }

  Future<void> updateReminder(MedicineReminderModel updatedReminder) async {
    final index = _reminders.indexWhere((e) => e.id == updatedReminder.id);
    if (index != -1) {
      _reminders[index] = updatedReminder;
      await saveReminders();
      notifyListeners();
    }
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((e) => e.id == id);
    await saveReminders();
    notifyListeners();
  }

  Future<void> updateReminderStatus(String id, String status) async {
    final index = _reminders.indexWhere((e) => e.id == id);
    if (index != -1) {
      _reminders[index] = _reminders[index].copyWith(status: status);
      await saveReminders();
      notifyListeners();
    }
  }

  Future<void> triggerReminderNotification(MedicineReminderModel reminder) async {
    final String title = 'Medicine Reminder 💊';
    final String body = 'Time to take ${reminder.medicineName} (${reminder.dosage}) - Scheduled for ${reminder.time}';

    if (kIsWeb) {
      debugPrint("Web Notification triggered: $title - $body");
      return;
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'medicine_reminders_channel',
      'Medicine Reminders',
      channelDescription: 'Notifications for medicine reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        reminder.id.hashCode,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      debugPrint("Error triggering local notification: $e");
    }
  }
}
