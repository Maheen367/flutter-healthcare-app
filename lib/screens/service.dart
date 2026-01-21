import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {

  Future InsertServices(Map<String, dynamic> Amap, String ID) async {
    await FirebaseFirestore.instance.collection('appointments').doc(ID).set(Amap);
  }


  Future<Stream<QuerySnapshot>> GetRecord() async {
    return await FirebaseFirestore.
    instance.
    collection('appointments').snapshots();
  }

  Future DeleteServices(String ID) async {
    await FirebaseFirestore.instance.collection('appointments').doc(ID).delete();
  }
  Future EditServices(Map<String, dynamic> Umap, String UID) async {
    await FirebaseFirestore.instance.collection('appointments').doc(UID).
    update(Umap);
  }
}