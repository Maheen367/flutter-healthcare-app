import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addpharmacy.dart';

class PharmacyListScreen extends StatefulWidget {
  const PharmacyListScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyListScreen> createState() => _PharmacyListScreenState();
}

class _PharmacyListScreenState extends State<PharmacyListScreen> {
  List<Map<String, dynamic>> pharmacyList = [];
  bool isLoading = true;

  // Sample 10 pharmacies
  final List<Map<String, dynamic>> samplePharmacies = [
    {
      "name": "Health Plus Pharmacy",
      "address": "Main Road, Burewala",
      "phone": "0301-1234567",
      "open": true,
    },
    {
      "name": "Sehat Medical Store",
      "address": "College Chowk, Burewala",
      "phone": "0302-9876543",
      "open": false,
    },
    {
      "name": "Ali Pharmacy",
      "address": "Model Town, Burewala",
      "phone": "0300-1122334",
      "open": true,
    },
    {
      "name": "Hamdard Pharmacy",
      "address": "Circular Road, Burewala",
      "phone": "0345-6655443",
      "open": true,
    },
    {
      "name": "Noor Medical Store",
      "address": "Chak 427/EB, Burewala",
      "phone": "0333-2299110",
      "open": false,
    },
    {
      "name": "CareWell Pharmacy",
      "address": "Vehari Road, Burewala",
      "phone": "0321-5566778",
      "open": true,
    },
    {
      "name": "Shifa Pharmacy",
      "address": "People’s Colony, Burewala",
      "phone": "0306-7788990",
      "open": true,
    },
    {
      "name": "City Chemist",
      "address": "LDA Market, Burewala",
      "phone": "0304-9988776",
      "open": false,
    },
    {
      "name": "Iqbal Pharmacy",
      "address": "Masjid Street, Burewala",
      "phone": "0307-4567890",
      "open": true,
    },
    {
      "name": "Zain Medical Store",
      "address": "Ghalla Mandi, Burewala",
      "phone": "0311-3344556",
      "open": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchPharmacies();
  }

  Future<void> fetchPharmacies() async {
    final snapshot = await FirebaseFirestore.instance.collection('pharmacies').get();
    final firebasePharmacies = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      pharmacyList = [...samplePharmacies, ...firebasePharmacies];
      isLoading = false;
    });
  }

  void _navigateToAddPharmacy() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PharmacyScreen()),
    );

    if (result != null) {
      fetchPharmacies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pharmacies in Burewala"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ?  Center(child: CircularProgressIndicator())
          : pharmacyList.isEmpty
          ?  Center(child: Text("No Pharmacies Found"))
          : ListView.builder(
        itemCount: pharmacyList.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final pharmacy = pharmacyList[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.local_pharmacy,
                color: pharmacy['open'] == true ? Colors.green : Colors.red,
                size: 36,
              ),
              title: Text(
                pharmacy['name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pharmacy['address'] ?? ''),
                  Text("📞 ${pharmacy['phone'] ?? ''}"),
                ],
              ),
              trailing: Chip(
                label: Text(
                  pharmacy['open'] == true ? 'Open' : 'Closed',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: pharmacy['open'] == true ? Colors.green : Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPharmacy,
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        tooltip: 'Add Pharmacy',
      ),
    );
  }
}
