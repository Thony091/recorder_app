import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recorder_app/config/router/app_router_notifier.dart';
import 'package:recorder_app/presentation/pages/pages_container.dart';
import 'package:recorder_app/presentation/presentation.dart';


final goRouterProvider = Provider( (ref) {

  final goRouterNotifier = ref.read( goRouterNotifierProvider );

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: 
      [
        GoRoute(
          path: '/splash', 
          name: CheckAuthStatusScreen.name, 
          builder: (context, state) => const CheckAuthStatusScreen()
        ),
        //* Home
        GoRoute(
          path: '/',
          name: HomePage.name,
          builder: (context, state) => const HomePage(),
        ),

        //* Login
        GoRoute(
          path: '/login',
          name: LoginPage.name,
          builder: (context, state) => const LoginPage(),
        ),

      ],

    redirect: (context, state) {

      final isGoingTo = state.fullPath;
      final authStatus = goRouterNotifier.authStatus;

      // Permitir acceso a la página de detalles del servicio sin autenticación
      if (isGoingTo.toString().startsWith('/service/')  && authStatus != AuthStatus.authenticated) {
        return null; // No redirigir, permitir el acceso
      }

      if ( isGoingTo == '/splash' && authStatus == AuthStatus.checking ) return null;

      if ( authStatus == AuthStatus.notAuthenticated ) {
        if ( isGoingTo == '/' ) return null;

        return '/login';
      }
      
      if ( authStatus == AuthStatus.notAuthenticated ) {
        if ( isGoingTo == '/login' ) return null;

        return '/';
      }

      if ( authStatus == AuthStatus.authenticated ) {
        if ( isGoingTo == '/login' || isGoingTo == '/splash' ){
          return '/';
        }
      }

      return null;
    }
  );
});