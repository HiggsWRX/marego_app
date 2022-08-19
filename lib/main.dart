import 'package:flutter/material.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Marego',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Container());
  }
}
