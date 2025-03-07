// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recorder_app/config/config.dart';
import 'package:recorder_app/presentation/presentation.dart';


class LoginPage extends StatelessWidget {

  static const name = 'LoginPage';
  
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    final color   = AppTheme().getTheme().colorScheme;
    
    return  SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Login",
          styleText: const TextStyle(
            color: Color.fromARGB(255, 246, 233, 223), 
            fontSize: 24, 
            fontWeight: FontWeight.w800,
            shadows: [
              Shadow(
                offset: Offset(1.0, 3.0),
                blurRadius: 3.0,
                color: Colors.black54
              )
            ]
          ),
          startColor: color.primary, 
          endColor: color.secondary,
        ),
        drawerEnableOpenDragGesture: false,
        body:  SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                const SizedBox( height: 75 ),
                FadeInUp(child: const _LoginForm()),
              ],
            ),
          )
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackBar( BuildContext context, String message ){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final loginFormState    = ref.watch(( loginFormProvider )); //para obtener el valor del state
    final loginFormNotifier = ref.read( loginFormProvider.notifier );

    ref.listen(authProvider, (previous, next) { 
      if ( next.errorMessage.isEmpty )  return;
      showSnackBar( context, next.errorMessage );
    });

    final size = MediaQuery.of(context).size;
    // final textStyles = Theme.of(context).textTheme;

    return Stack(
      children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Stack(
            children:[
             Column(
              children: [
                const SizedBox( height: 50 ),
                Container(
                  padding: const EdgeInsets.all(12),
                  height: size.height * 0.5,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 234, 234, 234),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black54,
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox( height: 60 ),
                      CustomProductField(
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          size: 30,
                          color: Colors.blue,
                        ),
                        isBottomField: true,
                        isTopField: true,
                        label: 'Correo',
                        textSize: 20,
                        textWeight: FontWeight.w600,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
                        errorMessage: loginFormState.isFormPosted 
                        ? loginFormState.email.errorMessage
                        : null,
                      ),
                      const SizedBox( height: 30 ),
                      CustomProductField(
                        suffixIcon: Icon(
                          !loginFormState.showPassword 
                            ? Icons.visibility_outlined 
                            : Icons.visibility_off_outlined,
                          size: 30,
                          color: !loginFormState.showPassword
                            ? Colors.blue
                            : Colors.red,
                        ),
                        onTapSuffixIcon: () => loginFormNotifier.setShowPass(),
                        isBottomField: true,
                        isTopField: true,
                        label: 'Contraseña',
                        textSize: 20,
                        textWeight: FontWeight.w600,
                        obscureText: !loginFormState.showPassword,
                        onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
                        errorMessage: loginFormState.isFormPosted
                        ? loginFormState.password.errorMessage
                        : null,
                      ),

                      const SizedBox(height: 45),
                  
                      CustomFilledButton(
                        height: 60,
                        width: size.width * 0.7,
                        radius: const Radius.circular(100),
                        shadowColor: const Color.fromARGB(255, 255, 255, 255),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offsetY: 3,
                        icon: Icons.person_2_rounded,
                        iconSeparatorWidth: 50,
                        text: 'Ingresar',
                        fontTextWeight: FontWeight.bold,
                        fontSize: 22,
                        buttonColor: Colors.blueAccent.shade400,
                        mainAxisAlignment: MainAxisAlignment.start,
                        onPressed: loginFormState.isPosting
                          ? null
                          : () async => await ref.read(loginFormProvider.notifier).onFormSubmit().then(
                            (_) async =>  ref.read( homeProvider.notifier ).getRemiders
                          )
                      ),
                      const SizedBox( height: 10),

                    ],
                  )
                ),  
              ],
            ),

            Center(
              heightFactor: .55,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 225, 191, 37),
                    width: 2,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/icons/recorder.png',
                    width: 130, 
                    height: 80, 
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            ]
          ),
        ),
      ),
      ]
    );
  }
}