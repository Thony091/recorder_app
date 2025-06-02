import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => const ProviderScope( child: MainApp() )
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appRouter = ref.watch( goRouterProvider );

    return  GestureDetector(
      onTap: () {
        final focus = FocusScope.of(context);
        final focusedChild = focus.focusedChild;
        if ( focusedChild != null && !focusedChild.hasPrimaryFocus ) focusedChild.unfocus();
        // FocusScope.of(context).unfocus();
      },
      child: MaterialApp.router(
        // themeAnimationStyle: AnimationStyle(
        //   curve: Curves.easeInOut,
        //   reverseCurve: Curves.easeInOut,
        //   duration: const Duration(milliseconds: 300),
        // ),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: AppTheme().getTheme(),
      ),
    );
  }
}
