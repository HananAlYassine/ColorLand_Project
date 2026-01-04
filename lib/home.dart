import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'MyDropdownMenuWidget.dart';
import 'Gender.dart';
import 'ListView.dart';
import 'package:flutter/cupertino.dart';
import 'global.dart';

// Base URL for backend API
const String _baseURL = 'http://hananalyassine.atwebpages.com';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  Gender selectedGender = genders.first;
  bool isSchoolKid = false;
  bool _loading = false;

  // Shows a SnackBar message and stops loading
  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  // Navigates to the next page
  void navigateToNextPage() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first!')),
      );
      return;
    }

    // Ensure data was saved before navigating
     if (globalChildId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please press SAVE first 🧠')),
      );
      return;
    }


    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Page2(
        //  name: _nameController.text, // PASS NAME
        ),
      ),
    );
  }


// Dispose controller to avoid memory leaks
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'ColorLand',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(CupertinoIcons.star_fill, color: Colors.yellow),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            //----- Top section: image + welcome text---------
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset('assets/color3.png', fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Welcome to ColorLand 🖌️🌟\n\nHere, you will learn colors in a fun and easy way! 🎨🎈',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Comic Sans MS',
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            //------------ Name input row --------------
            Row(
              children: [
                const Text(
                  'Enter Your Name:  ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            //------- Gender selection row -----------
            Row(
              children: [
                const Text(
                  'Select Gender:  ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MyDropdownMenuWidget(
                  updateGender: (Gender gender) {
                    setState(() {
                      selectedGender = gender;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            //---------- School kid checkbox ----------
            Row(
              children: [
                Checkbox(
                  value: isSchoolKid,
                  onChanged: (bool? value) {
                    setState(() {
                      isSchoolKid = value ?? false;
                    });
                  },
                ),
                const Text(
                  'Are you a school kid?',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            //---------- SAVE and NEXT buttons ---------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // --------------- SAVE button --------------
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () {
                    if (_nameController.text.trim().isEmpty) {
                      update('Please enter your name');
                      return;
                    }
                    // Show loading indicator
                    setState(() {
                      _loading = true;
                    });

                    // Call backend to save child data
                    saveChild(
                      update,
                      _nameController.text,
                      selectedGender.gender,
                      isSchoolKid ? 1 : 0,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Comic Sans MS',
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                //------------ NEXT button ----------
                ElevatedButton(
                  onPressed: navigateToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Comic Sans MS',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Loading spinner shown while saving
            Visibility(
              visible: _loading,
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SAVE FUNCTION =================
// Sends child data to the backend and saves it globally
void saveChild(
    Function(String text) update,
    String name,
    String gender,
    int isSchoolKid,
    ) async {
  try {
    // Send POST request to backend
    final response = await http.post(
      Uri.parse('$_baseURL/save_child.php'),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({
        'name': name,
        'gender': gender,
        'is_school_kid': isSchoolKid,
      }),
    );

    // If request is successful
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);

      // Save child info globally
      globalChildId = data['child_id'];
      globalChildName = name;

      update("Child saved successfully");
    } else {
      update("Server error");
    }
  } catch (e) {
    update("Network error");
  }
}
