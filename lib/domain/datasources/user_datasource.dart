
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class UserDatasource {

  Future<firebase_auth.UserCredential> login (String email, String password);
 
}