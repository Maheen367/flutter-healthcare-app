import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isOpen = true;
  String? _editingId;

  void _submit() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || address.isEmpty || phone.isEmpty) return;

    final pharmacyData = {
      'name': name,
      'address': address,
      'phone': phone,
      'open': _isOpen,
    };

    final ref = FirebaseFirestore.instance.collection('pharmacies');

    if (_editingId == null) {
      await ref.add(pharmacyData);
    } else {
      await ref.doc(_editingId).update(pharmacyData);
    }

    _clearFields();
  }

  void _clearFields() {
    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _isOpen = true;
    _editingId = null;
    setState(() {});
  }

  void _startEditing(Map<String, dynamic> data, String id) {
    _nameController.text = data['name'] ?? '';
    _addressController.text = data['address'] ?? '';
    _phoneController.text = data['phone'] ?? '';
    _isOpen = data['open'] ?? true;
    _editingId = id;
    setState(() {});
  }

  void _deletePharmacy(String id) async {
    await FirebaseFirestore.instance.collection('pharmacies').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Pharmacy Management'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration:  InputDecoration(labelText: 'Pharmacy Name'),
                ),
                TextField(
                  controller: _addressController,
                  decoration:  InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                SwitchListTile(
                  title: const Text('Open'),
                  value: _isOpen,
                  onChanged: (val) {
                    setState(() {
                      _isOpen = val;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_editingId == null ? 'Add Pharmacy' : 'Update Pharmacy'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
              ],
            ),
          ),
           Divider(thickness: 1),
           Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Pharmacy List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('pharmacies').snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return  Center(child: CircularProgressIndicator());
                }

                final docs = snap.data?.docs ?? [];

                if (docs.isEmpty) {
                  return  Center(child: Text('No pharmacies found'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final doc = docs[i];
                    final data = doc.data() as Map<String, dynamic>;

                    return Card(
                      margin:  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: Icon(
                          Icons.local_pharmacy,
                          color: (data['open'] ?? false) ? Colors.green : Colors.grey,
                        ),
                        title: Text(data['name'] ?? ''),
                        subtitle: Text('${data['address']}\n📞 ${data['phone']}'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:  Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _startEditing(data, doc.id),
                            ),
                            IconButton(
                              icon:  Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletePharmacy(doc.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
