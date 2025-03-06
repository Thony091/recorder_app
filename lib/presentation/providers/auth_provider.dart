
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recorder_app/config/config.dart';
import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/infrastructure/infrastructure.dart';

/// Proveedor de estado para la gestión de la autenticación.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  
  final authRepository = UserRepositoryImpl(); 
  final keyValueStorageService = KeyValueStorageServiceImpl();
  
  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService
  );
});

/// Clase notificadora de estado para la gestión de la autenticación.
class AuthNotifier extends StateNotifier<AuthState>{
  
  final UserRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }): super(AuthState()){
    checkAuthStatus();
  }

  /// Método para verificar el estado de autenticación.
  void checkAuthStatus() async {
    
    final token = await keyValueStorageService.getValue<String>('token');
    final email = await keyValueStorageService.getValue<String>('email');
    final password = await keyValueStorageService.getValue<String>('password');
    
    if( token == null ) return logOut();

    try {

      await loginUserFireBase(email.toString(), password.toString());
      
    } catch (e) {
      logOut();
    }

  }

  /// Método para iniciar sesión de un usuario.
  Future<void> loginUserFireBase( String email, String password ) async {

    await Future.delayed(const Duration(milliseconds: 500));

    try {

      final user = await FirebaseAuthService.auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      await keyValueStorageService.setKeyValue('email', email);
      await keyValueStorageService.setKeyValue('password', password);
      await keyValueStorageService.setKeyValue('userId', user.user!.uid);

      _setLoggedUser( user );

    } on CustomError {
      logOut( 'Credenciales no son correctas' );
    } catch(e){
      logOut('Error no controlado');
    }
    print('Status desde logIn(): ${state.authStatus}');
  }

  /// Método privado para establecer el usuario autenticado. 
  void _setLoggedUser ( firebase_auth.UserCredential user ) async {

    final tokenId = await user.user!.getIdToken();
 
    // Verifica si tokenId es null antes de intentar almacenarlo.
    if ( tokenId != null ) {

      await keyValueStorageService.setKeyValue('token', tokenId);

    } else {
      print('Token ID is null');
    }
    
    final token = await keyValueStorageService.getValue<String>('token');
    print('Token guardado?: $token');

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
      token: tokenId,
    );

  }

  /// Método para cerrar sesión del usuario.
  Future<void> logOut([ String? errorMessage ]) async {

    try {
      
      await FirebaseAuthService.logOut();
      
      await keyValueStorageService.removeKey('token');
      await keyValueStorageService.removeKey('email');
      await keyValueStorageService.removeKey('password');
      print('Token eliminado correctamente');
      
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage
      );
      print('Status desde logOut(): ${state.authStatus}');
      
    } catch (e) {
      print(e); 
    }
  }
}

/// Enumeración que representa los posibles estados de autenticación.
enum AuthStatus{ checking, authenticated, notAuthenticated}

/// Clase que representa el estado de la autenticación.
class AuthState {
   
  final AuthStatus authStatus;
  final firebase_auth.UserCredential? user;
  final String errorMessage;
  final String token;


  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = '',
    this.token = '',
  });

  /// Método para crear una copia del estado con cambios específicos.
  AuthState copyWith({
    AuthStatus? authStatus,
    firebase_auth.UserCredential? user,
    String? errorMessage,
    String? token,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
    token: token ?? this.token
  );

  @override
  String toString() {
    return '''
      AuthState:
      authStatus: $authStatus, 
      user: $user, 
      errorMessage: $errorMessage, 
      token: $token
    ''';
  }

  void addListener(Null Function(dynamic state) param0) {}

}