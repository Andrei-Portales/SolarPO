import 'package:flutter/material.dart';
import 'package:solar_app/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portales Solar',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(11, 61, 145, 1),
        ),
      ),
      home: const Home(),
    );
  }
}
