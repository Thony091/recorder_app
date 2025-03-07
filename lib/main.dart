import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'config/config.dart';
import 'config/router/router_container.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await FirebaseService.init();
  
  await NotificationService.initialize(); // Inicializar Notificaciones

  // Pedir permisos en iOS
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  
  runApp(
    const ProviderScope(child: MainApp() )
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appRouter = ref.watch( goRouterProvider );

    return  MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      
    );
  }
}
