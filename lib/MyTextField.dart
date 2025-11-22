import 'package:flutter/material.dart';


class MyTextField extends StatelessWidget {
  Function(String) f; // hold a variable function
  String hint; // holds the hintText of the TextField

  MyTextField({required this.hint, required this.f, super.key,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 250.0, height: 50.0,
      child: TextField(
        style: const TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
            border: const OutlineInputBorder(), hintText: hint
        ),
        onChanged: (text) { f(text);}, // call the variable function
      ),
    );
  }
}