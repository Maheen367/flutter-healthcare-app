import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'appointment_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController specialityController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot>? appointmentStream;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  void fetchAppointments() {
    setState(() {
      appointmentStream = FirebaseFirestore.instance
          .collection('appointments')
          .orderBy('timestamp', descending: true)
          .snapshots();
    });
  }

  Future<void> _editAppointment(String id) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text("Edit Appointment"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: doctorController,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter doctor name' : null,
                  decoration: InputDecoration(
                    labelText: 'Doctor',
                    border: OutlineInputBorder(),
                  ),
                ),
             SizedBox(height: 10),
                TextFormField(
                  controller: dateController,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter date' : null,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                ),
                 SizedBox(height: 10),
                TextFormField(
                  controller: timeController,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter time' : null,
                  decoration:  InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                  ),
                ),
               SizedBox(height: 10),
                TextFormField(
                  controller: specialityController,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter reason' : null,
                  decoration: InputDecoration(
                    labelText: 'Reason',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await FirebaseFirestore.instance
                    .collection('appointments')
                    .doc(id)
                    .update({
                  'doctor': doctorController.text,
                  'date': dateController.text,
                  'time': timeController.text,
                  'speciality': specialityController.text,
                });
                Fluttertoast.showToast(msg: "Appointment updated");
                Navigator.pop(context);
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList() {
    return StreamBuilder<QuerySnapshot>(
      stream: appointmentStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return  Center(child: Text("No appointments found."));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            return Card(
              elevation: 4,
              margin:  EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text("Dr. ${doc['doctor']}", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: ${doc['date']}"),
                    Text("Time: ${doc['time']}"),
                    Text("speciality: ${doc['speciality']}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon:  Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        doctorController.text = doc['doctor'];
                        dateController.text = doc['date'];
                        timeController.text = doc['time'];
                        specialityController.text = doc['speciality'];
                        _editAppointment(doc.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(doc.id)
                            .delete();
                        Fluttertoast.showToast(msg: "Appointment deleted");
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Appointments"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding:  EdgeInsets.all(12.0),
        child: _buildAppointmentList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppointmentScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
