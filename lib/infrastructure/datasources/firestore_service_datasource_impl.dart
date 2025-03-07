import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recorder_app/domain/domain.dart';

class FirestoreServiceDatasourceImpl implements FirestoreServiceDatasource {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Future addDataToFirestore(Map<String, dynamic> data, String collectionName, String docName) async {
    try {  
      
      await _firestore.collection(collectionName).doc(docName).set(data);

    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String,dynamic>> getDataFromFirestore(String collectionName, String docName) async{

    try {
      final userData = await _firestore.collection(collectionName).doc(docName).get();

      if (userData.data() == null) {
        throw Exception('No data found');
      }

      return userData.data() as Map<String,dynamic>;
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
  
  @override
  Future updateDataInFirestore(Map<String, dynamic> data, String collectionName, String docName) async {
    try {
      await _firestore.collection(collectionName).doc(docName).update( data );
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

}