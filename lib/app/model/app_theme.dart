import 'package:atom/gen/colors.gen.dart';
import 'package:atom/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const TextTheme lightTextTheme = TextTheme(
    //
    displayLarge: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      height: 64 / 57,
      color: ColorName.darkGray,
    ),
    //
    displayMedium: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 45,
      fontWeight: FontWeight.w400,
      height: 52 / 45,
      color: ColorName.darkGray,
    ),
    //
    displaySmall: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 36,
      fontWeight: FontWeight.w400,
      height: 40 / 36,
      color: ColorName.darkGray,
    ),
    //
    headlineLarge: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 32,
      fontWeight: FontWeight.w400,
      height: 40 / 32,
      color: ColorName.darkGray,
    ),
    //
    headlineMedium: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 28,
      fontWeight: FontWeight.w400,
      height: 36 / 28,
      color: ColorName.darkGray,
    ),
    //
    headlineSmall: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: -.8,
      color: ColorName.darkGray,
    ),
    //
    titleLarge: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 22,
      fontWeight: FontWeight.w500,
      height: 26 / 22,
      color: ColorName.darkGray,
    ),
    //
    titleMedium: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 20 / 16,
      color: ColorName.darkGray,
    ),
    //
    titleSmall: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 18 / 14,
      color: ColorName.darkGray,
    ),
    //
    labelLarge: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 18 / 14,
      color: ColorName.darkGray,
    ),
    //
    labelMedium: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      color: ColorName.darkGray,
    ),
    //
    labelSmall: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: ColorName.darkGray,
    ),
    //
    bodyLarge: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 20 / 16,
      color: ColorName.darkGray,
    ),
    //
    bodyMedium: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 18 / 14,
      color: ColorName.darkGray,
    ),
    //
    bodySmall: TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      color: ColorName.darkGray,
    ),
  );
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    textTheme: lightTextTheme,
    fontFamily: FontFamily.montserrat,
  );
}
