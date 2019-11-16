import 'package:flutter/material.dart';
import 'package:drink_app/widgets/home.dart' as Home;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drink App',
      home: Home.DrinkApp(),
    );
  }
}