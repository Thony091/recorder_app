import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:recorder_app/config/services/firebase/firebase.dart';
import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/infrastructure/infrastructure.dart';

class UserDatasourceImpl extends UserDatasource {
  
  @override
  Future<firebase_auth.UserCredential> login(String email, String password) async {

    try {
      final firebase_auth.UserCredential userCredential = await FirebaseAuthService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Error de autentificación: $e');
      throw CustomError("Errrrror: ${e.toString()}");
    }

  }

}