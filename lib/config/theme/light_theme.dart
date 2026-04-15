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
);