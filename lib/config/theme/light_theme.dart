import 'dart:io';
import 'package:flutter/material.dart';
import '../../utils/constants/app_colors.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: Platform.isIOS ? null : 'Roboto',
  useMaterial3: true,

  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,

  appBarTheme: const AppBarTheme(
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    backgroundColor: AppColors.background,
    centerTitle: true,
  ),

  textTheme: const TextTheme(
    // Title
    titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

    // Display
    displayLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    displayMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    displaySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  ),
);
