import 'package:flutter/material.dart';
import 'package:untitled22/screens/schedule.dart';

import 'doctors_screen.dart';
import 'pharmacy_screen.dart';
import 'message_screen.dart';
import 'reminder_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Map<String, dynamic>> getCategories(BuildContext context) {
    return [
      {
        "icon": Icons.local_hospital,
        "label": "Doctors",
        "screen": DoctorScreen(),
        "color": Colors.blue.shade100,
      },
      {
        "icon": Icons.medical_services,
        "label": "Pharmacy",
        "screen":  PharmacyListScreen(),
        "color": Colors.green.shade100,
      },
      {
        "icon": Icons.message,
        "label": "Message",
        "screen": MessageScreen(),
        "color": Colors.orange.shade100,
      },
      {
        "icon": Icons.notifications_active,
        "label": "Notification",
        "screen":  NotificationScreen(),
        "color": Colors.red.shade100,
      },
      {
        "icon": Icons.alarm,
        "label": "Reminder",
        "screen":  ReminderScreen(),
        "color": Colors.amber.shade100,
      },
      {
        "icon": Icons.schedule,
        "label": "Schedule",
        "screen": ScheduleScreen(),
        "color": Colors.cyan.shade100,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final categories = getCategories(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('Health Dashboard'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "Categories",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => category['screen']),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: category['color'],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset:  Offset(2, 4),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category['icon'],
                              size: 36, color: Colors.blueGrey),
                          const SizedBox(height: 10),
                          Text(
                            category['label'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
