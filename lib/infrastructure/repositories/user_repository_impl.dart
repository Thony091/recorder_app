import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/infrastructure/infrastructure.dart';


class UserRepositoryImpl implements UserRepository {

  final UserDatasource datasource;

  UserRepositoryImpl( {
    UserDatasource? datasource
  }) : datasource = datasource ?? UserDatasourceImpl();

  @override
  Future<firebase_auth.UserCredential> login(String email, String password) async {
    return await datasource.login(email, password);
  }
  
}