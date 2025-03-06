abstract class FirestoreServiceDatasource {
  Future addDataToFirestore(Map<String, dynamic> data, String collectionName, String docName);

  Future<Map<String,dynamic>> getDataFromFirestore(String collectionName, String docName);

}