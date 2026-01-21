import 'package:flutter/material.dart';
import 'appointment_screen.dart';

class DoctorScreen extends StatelessWidget {
  final List<Map<String, dynamic>> doctorsData = [
    {
      'name': 'Dr. Ayesha Khan',
      'specialty': 'Cardiologist',
      'experience': '10 years',
      'location': 'Burewala Medical Center',
      'rating': 4.8,
      'image': 'assets/d2.png',
      'about': 'Expert in heart-related diseases and cardiac care.'
    },
    {
      'name': 'Dr. Hassan Raza',
      'specialty': 'Dermatologist',
      'experience': '7 years',
      'location': 'Skin Care Hospital',
      'rating': 4.6,
      'image': 'assets/d1.png',
      'about': 'Treats acne, eczema, and cosmetic skin issues.'
    },
    {
      'name': 'Dr. Sara Ahmed',
      'specialty': 'Pediatrician',
      'experience': '5 years',
      'location': 'City Children Clinic',
      'rating': 4.7,
      'image': 'assets/d5.jpg',
      'about': 'Child health, newborn care, vaccinations.'
    },
    {
      'name': 'Dr. Waleed Yousaf',
      'specialty': 'Neurologist',
      'experience': '12 years',
      'location': 'Neuro Care, Burewala',
      'rating': 4.9,
      'image': 'assets/d3.png',
      'about': 'Treats epilepsy, migraines, stroke rehab.'
    },
    {
      'name': 'Dr. Rabia Fatima',
      'specialty': 'Dentist',
      'experience': '6 years',
      'location': 'Bright Smile Dental Clinic',
      'rating': 4.5,
      'image': 'assets/d2.png',
      'about': 'Dental care, root canals, oral hygiene.'
    },
    {
      'name': 'Dr. Faizan Ali',
      'specialty': 'Orthopedic Surgeon',
      'experience': '11 years',
      'location': 'Orthopedic Center',
      'rating': 4.8,
      'image': 'assets/d1.png',
      'about': 'Bone fractures, joint surgeries.'
    },
    {
      'name': 'Dr. Hina Siddiqui',
      'specialty': 'Gynecologist',
      'experience': '9 years',
      'location': 'Women Wellness Clinic',
      'rating': 4.7,
      'image': 'assets/d5.jpg',
      'about': 'Fertility, pregnancy, reproductive health.'
    },
    {
      'name': 'Dr. Kamran Tariq',
      'specialty': 'ENT Specialist',
      'experience': '8 years',
      'location': 'ENT Care Hospital',
      'rating': 4.6,
      'image': 'assets/d3.png',
      'about': 'Ear, nose, throat issues and surgeries.'
    },
    {
      'name': 'Dr. Mahnoor Zafar',
      'specialty': 'Psychiatrist',
      'experience': '5 years',
      'location': 'Mind Wellness Center',
      'rating': 4.4,
      'image': 'assets/d5.jpg',
      'about': 'Mental health, therapy, depression care.'
    },
    {
      'name': 'Dr. Bilal Sheikh',
      'specialty': 'Urologist',
      'experience': '10 years',
      'location': 'Kidney Hospital',
      'rating': 4.7,
      'image': 'assets/d3.png',
      'about': 'Kidney, bladder, urinary treatments.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Doctors")),
      body: ListView.builder(
        padding:  EdgeInsets.all(12),
        itemCount: doctorsData.length,
        itemBuilder: (context, index) {
          final doctor = doctorsData[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin:  EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(radius: 30, backgroundImage: AssetImage(doctor['image'])),
              title: Text(doctor['name'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(doctor['specialty']),
              trailing:  Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoctorDetailScreen(doctor: doctor),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DoctorDetailScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetailScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doctor['name'])),
      body: Padding(
        padding:  EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(radius: 60, backgroundImage: AssetImage(doctor['image'])),
             SizedBox(height: 16),
            Text(doctor['name'], style:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(doctor['specialty'], style:  TextStyle(fontSize: 16, color: Colors.grey)),
             SizedBox(height: 10),
            Text('Experience: ${doctor['experience']}'),
            Text('Location: ${doctor['location']}'),
             SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(Icons.star, color: Colors.orange, size: 20),
                Text('${doctor['rating']} / 5.0'),
              ],
            ),
             SizedBox(height: 20),
             Align(
              alignment: Alignment.centerLeft,
              child: Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
             SizedBox(height: 8),
            Text(doctor['about']),
             Spacer(),
            ElevatedButton.icon(
              icon:  Icon(Icons.calendar_month),
              label: Text("Book Appointment"),
              style: ElevatedButton.styleFrom(
                padding:  EdgeInsets.symmetric(vertical: 14),
                minimumSize:Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
