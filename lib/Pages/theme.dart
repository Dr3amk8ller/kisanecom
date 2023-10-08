import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.poppins().fontFamily,
        cardColor: Colors.white,
        canvasColor: creamColor,
        colorScheme:
            ColorScheme.light(primary: tale, secondary: Colors.deepPurple),
        hintColor: tale,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.red, // Set the background color of the button
          textTheme: ButtonTextTheme.primary,

          // Set the text color of the button
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          // You can keep this as it is.
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.poppins().fontFamily,
        cardColor: Colors.black,
        canvasColor: darkCreamColor,
        hintColor: Colors.white,
        colorScheme: const ColorScheme.dark(
            primary: Colors.white, secondary: Colors.white),
        buttonTheme: ButtonThemeData(
          buttonColor:
              lightBluishColor, // Set the background color of the button
          textTheme: ButtonTextTheme.primary,
          // Set the text color of the button
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      );

  //Colors
  static Color creamColor = const Color(0xfff5f5f5);
  static Color darkCreamColor = Vx.gray900;
  static Color darkBluishColor = const Color(0xff403b58);
  static Color lightBluishColor = Vx.indigo500;
  static Color tale = const Color(0Xff008080);

  // Define the secondary color for the light theme
  static const Color secondaryColorLight = Colors.blueGrey;

  // Define the secondary color for the dark theme
  static const Color secondaryColorDark = Colors.white;
}
