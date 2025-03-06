import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/infrastructure/infrastructure.dart';

class FirestoreServiceRepositoryImpl implements FirestoreServiceRepository {

  final FirestoreServiceDatasource datasource;

  FirestoreServiceRepositoryImpl({
    FirestoreServiceDatasource? datasource
  }) : datasource = datasource ?? FirestoreServiceDatasourceImpl();
  
  @override
  Future addDataToFirestore(Map<String, dynamic> data, String collectionName, String docName) async {
    await datasource.addDataToFirestore(data, collectionName, docName);
  }
  
  @override
  Future<Map<String,dynamic>> getUserDataFromFirestore(String collectionName, String docName) async {
    return await datasource.getDataFromFirestore(collectionName, docName);
  }
  
}