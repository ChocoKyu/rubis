import "package:flutter/material.dart";
import "package:rubis/connexion.dart";

void main() async {
  // map de couleur pour le theme de l'application
  Color red = const Color.fromARGB(255, 100, 20, 20);
  Color accent = const Color.fromARGB(153, 63, 19, 14);
  Color grey = const Color.fromRGBO(105, 105, 105, 1);
  Color black = const Color.fromARGB(255, 20, 20, 20);

  runApp(
    MaterialApp(
      // structure de l'application
      debugShowCheckedModeBanner: false,
      home: const Connexion(),
      theme: ThemeData(
        scaffoldBackgroundColor: black,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: red,
          onPrimary: black,
          secondary: accent,
          onSecondary: grey,
          background: Colors.orange,
          onBackground: Colors.green,
          surface: Colors.blue,
          onSurface: Colors.pink,
          error: Colors.deepPurple,
          onError: Colors.brown,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: grey,
          actionTextColor: black,
        ),
        dividerColor: red,
        iconTheme: IconThemeData(color: red, size: 40.0),
        appBarTheme: AppBarTheme(
          toolbarTextStyle: TextStyle(color: black),
          titleTextStyle: TextStyle(color: black),
          color: red,
          iconTheme: IconThemeData(color: black),
        ),
        listTileTheme: ListTileThemeData(iconColor: red),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: red,
          ),
        ),
        checkboxTheme:
            CheckboxThemeData(fillColor: MaterialStateProperty.all(red)),
        fontFamily: "ZenKurenaido",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    ),
  );
}
