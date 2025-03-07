
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recorder_app/config/config.dart';
import 'package:recorder_app/presentation/pages/home/views/home_body_view.dart';
import 'package:recorder_app/presentation/pages/home/views/reminder_form_view.dart';
import 'package:recorder_app/presentation/presentation.dart';

class HomePage extends ConsumerStatefulWidget {

  static const name = 'HomePage';

  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
} 

class HomePageState extends ConsumerState<HomePage>{

  @override
  void initState() {
    super.initState();
    
    Future.microtask(() => ref.read(homeProvider.notifier).getRemiders());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context ) {

    final authStatusProvider  = ref.watch( authProvider );
    final color               = AppTheme().getTheme().colorScheme;
    final scaffoldKey         = GlobalKey<ScaffoldState>();
    final homeState           = ref.watch(homeProvider);

    return  Scaffold(
      drawer:  SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        iconTheme: IconThemeData(
          size: 35,
          weight: 45
        ),
        title: Text( (authStatusProvider.authStatus == AuthStatus.authenticated)
          ? 'Hola ${authStatusProvider.user!.user!.email}'
          : 'Hola Invitado'
        ),
        backgroundColor: color.primary,
      ),
      body: !homeState.isFormSelected 
        ? HomeBodyView()
        : ReminderFormView()
    );
  }
}
