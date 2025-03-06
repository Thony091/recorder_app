abstract class FirestoreServiceRepository {
  Future addDataToFirestore(Map<String, dynamic> data, String collectionName, String docName);

  Future<Map<String,dynamic>> getUserDataFromFirestore(String collectionName, String docName);

}