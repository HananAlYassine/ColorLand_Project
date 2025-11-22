import 'package:flutter/material.dart';
import 'Gender.dart';

class MyDropdownMenuWidget extends StatefulWidget {
  const MyDropdownMenuWidget({required this.updateGender, super.key});
  final Function(Gender) updateGender;

  @override
  State<MyDropdownMenuWidget> createState() => _MyDropdownMenuWidgetState();
}

class _MyDropdownMenuWidgetState extends State<MyDropdownMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        width: 210.0,
        initialSelection: genders[0],
        onSelected: (gender) {
          setState(() {
            widget.updateGender( gender as Gender); // use widget to access widget fields from state class
          });
        },
        dropdownMenuEntries: genders.map<DropdownMenuEntry<Gender>>((Gender gender) {
          return DropdownMenuEntry(value: gender, label: gender.toString());
        }).toList());
  }
}
