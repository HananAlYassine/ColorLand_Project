import 'package:flutter/material.dart';
import 'home.dart';


void main() {
  runApp(const ColorTeachingApp());
}

class ColorTeachingApp extends StatelessWidget {
  const ColorTeachingApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Teaching App for Kids',
      debugShowCheckedModeBanner: false,  // Removes the "debug" banner from the corner
      theme: ThemeData(
        primarySwatch: Colors.purple,  // Sets the main theme color of the app
        scaffoldBackgroundColor: Colors.pink[50], // Sets the background of all screens
      ),
      home: const HomePage(), // First screen shown when the app opens
    );
  }
}
