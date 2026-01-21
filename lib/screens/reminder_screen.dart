import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _medicineController = TextEditingController();
  TimeOfDay? _selectedTime;
  List<Map<String, String>> _reminders = [];
  List<Map<String, String>> _firebaseReminders = [];

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadLocalReminders();
    _loadFirebaseReminders();
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addReminder() async {
    if (_medicineController.text.isEmpty || _selectedTime == null) return;

    final newReminder = {
      'medicine': _medicineController.text,
      'time': _selectedTime!.format(context),
    };

    setState(() {
      _reminders.add(newReminder);
      _medicineController.clear();
      _selectedTime = null;
    });

    await _saveLocalReminders();

    // Save to Firebase
    if (userId != null) {
      await FirebaseFirestore.instance.collection('reminders').add({
        'uid': userId,
        'medicine': newReminder['medicine'],
        'time': newReminder['time'],
        'createdAt': Timestamp.now(),
      });
      _loadFirebaseReminders(); // refresh list
    }
  }

  void _deleteReminder(int index) async {
    setState(() {
      _reminders.removeAt(index);
    });
    await _saveLocalReminders();
  }

  Future<void> _saveLocalReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_reminders);
    await prefs.setString('reminders', encoded);
  }

  Future<void> _loadLocalReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString('reminders');
    if (encoded != null) {
      final List<dynamic> decoded = jsonDecode(encoded);
      setState(() {
        _reminders = decoded
            .map<Map<String, String>>((item) => Map<String, String>.from(item))
            .toList();
      });
    }
  }

  Future<void> _loadFirebaseReminders() async {
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('reminders')
        .where('uid', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    final List<Map<String, String>> reminders = snapshot.docs.map((doc) {
      final data = doc.data(); // Map<String, dynamic>
      return {
        'medicine': data['medicine'].toString(),
        'time': data['time'].toString(),
      };
    }).toList();

    setState(() {
      _firebaseReminders = reminders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Medicine Reminder")),
      body: Padding(
        padding:  EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _medicineController,
              decoration:  InputDecoration(
                labelText: "Medicine Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickTime,
                  child: Text("Pick Time"),
                ),
                 SizedBox(width: 16),
                Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context)
                      : "No time selected",
                  style:  TextStyle(fontSize: 16),
                ),
              ],
            ),
        SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addReminder,
              icon:  Icon(Icons.alarm),
              label: Text("Set Reminder"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Local Reminders",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        SizedBox(height: 12),
            Expanded(
              child: _reminders.isEmpty
                  ? const Center(child: Text("No local reminders yet"))
                  : ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.medication,
                          color: Colors.blue),
                      title: Text(reminder['medicine']!),
                      subtitle: Text("Time: ${reminder['time']}"),
                      trailing: IconButton(
                        icon:  Icon(Icons.delete,
                            color: Colors.red),
                        onPressed: () => _deleteReminder(index),
                      ),
                    ),
                  );
                },
              ),
            ),

             SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: _firebaseReminders.isEmpty
                  ?  Center()
                  : ListView.builder(
                itemCount: _firebaseReminders.length,
                itemBuilder: (context, index) {
                  final reminder = _firebaseReminders[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.cloud_done,
                          color: Colors.green),
                      title: Text(reminder['medicine']!),
                      subtitle: Text("Time: ${reminder['time']}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
