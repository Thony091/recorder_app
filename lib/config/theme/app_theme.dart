


import 'package:flutter/material.dart';

class AppTheme {

  static const Color primary = Color.fromARGB(255, 42, 155, 248);
  static const Color secondary = Color.fromARGB(255, 195, 218, 252);
  static const Color accent = Color(0xFF61C19C);
  static const Color background = Color(0xFFEBEBEB);

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      secondary: secondary,
      surface: background,
      background: background,
      error: Colors.redAccent,
      onPrimary: Colors.white, // text color on the primary color
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ), // For title 
      titleMedium: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ), 
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ), 
      bodyMedium: TextStyle(
        fontSize: 17,
        color: Colors.black87,
      ), 
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ), // For little descriptions
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: secondary,
      ), // For buttons like "Watch List"
    ),
  );


}