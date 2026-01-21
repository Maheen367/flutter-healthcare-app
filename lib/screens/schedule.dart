import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  Stream<QuerySnapshot> getAppointments() {
    return FirebaseFirestore.instance
        .collection('appointments')
        .orderBy('timestamp')
        .snapshots();
  }

  String formatTimestamp(Timestamp timestamp) {
    final DateTime dt = timestamp.toDate();
    return DateFormat('MMM d, yyyy – hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Schedule'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return  Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return  Center(child: Text('No schedules found'));

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final doctor = appointment['doctor'] ?? 'Unknown';
              final patient = appointment['uid'] ?? 'Unknown';
              final speciality = appointment['speciality'] ?? '';
              final time = appointment['time'] ?? '';
              final date = appointment['date'] ?? '';
              final timestamp = appointment['timestamp'] as Timestamp;

              return Container(
                margin:  EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade300, Colors.teal.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding:  EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Gradient Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.tealAccent],
                          ),
                        ),
                        padding:  EdgeInsets.all(4),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.schedule, color: Colors.teal, size: 30),
                        ),
                      ),
                      SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doctor,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(speciality,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                )),
                             SizedBox(height: 6),
                            Text('🗓 $date at $time',
                                style:  TextStyle(
                                    color: Colors.white70, fontSize: 14)),
                            Text('👤 UID: $patient',
                                style:  TextStyle(
                                    color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                      // Time
                      Column(
                        children: [
                          Icon(Icons.chevron_right, color: Colors.white),
                          Text(formatTimestamp(timestamp),
                              style: TextStyle(
                                  fontSize: 10, color: Colors.white60)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
