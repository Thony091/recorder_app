import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  static late FirebaseAuth auth;

  static void init(){
    auth = FirebaseAuth.instance;
  }

  static Future<void> logOut() async {
    await auth.signOut();
  }

}