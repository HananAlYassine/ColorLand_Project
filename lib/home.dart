// Hanan and Rehab Project
import 'package:flutter/material.dart';
import 'MyTextField.dart';
import 'MyDropdownMenuWidget.dart';
import 'Gender.dart';
import 'ListView.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _name ='';  // Stores the child's name
  final TextEditingController _nameController = TextEditingController(); // Controller for the name field
  String? _gender; // Stores selected gender as text

  // Getter to access name
  String get name => _name;

  Gender selectedGender = genders.first; // Default selected gender

  // Updates checkbox when changed in checkbox
  bool isSchoolKid = false;

  // Updates gender when changed in dropdown
  void updateGender(Gender gender) {
    setState(() {
      selectedGender = gender;
      _gender = gender.toString();
    });
  }

  // Updates name when typed in the text field
  void updatename(String x) {
    setState(() {
      _name = x;
    });
  }

// ------------------ UI BUILD ------------------

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
            Icon(
              CupertinoIcons.star_fill,
              color: Colors.yellow,
              size: 24,
            ),
          ],
        ),

        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ------------------ IMAGE + INTRO SECTION ------------------
            Row(
              children: [
                // Left: Local asset image with rounded corners and background
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.purple[100], // background behind the image
                      borderRadius: BorderRadius.circular(20), // rounded corners
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 4),  // Soft shadow
                        ),
                      ],
                    ),

                    clipBehavior: Clip.antiAlias, // Makes image follow rounded corners
                    child: Image.asset(
                      'assets/color3.png',
                      fit: BoxFit.cover, // Fills the space
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // RIGHT: Welcome text
                Expanded(
                  flex: 2,
                  child: Text(
                    'Welcome to ColorLand 🖌️🌟\n\nHere, you will learn colors in a fun and easy way! 🎨🎈',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Comic Sans MS',
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),


            // ------------------ NAME INPUT ------------------            const SizedBox(height: 19),
            Row(
              children: <Widget>[
                Text('Enter Your Name:  ',
                    style: const TextStyle(
                      fontSize: 20.0 ,
                      color: Colors.deepPurpleAccent ,
                      fontWeight: FontWeight.bold,
                    )
                ),
                const SizedBox(height: 19),
                MyTextField(f: updatename, hint: ''), // Custom text field → sends name to updatename()

              ],
            ),
            const SizedBox(height: 20),

            // ------------------ GENDER SELECT ------------------
            const SizedBox(height: 19),

            Row(
              children: <Widget>[
                Text('Select Gender:  ',
                    style: const TextStyle(
                      fontSize: 20.0 ,
                      color: Colors.deepPurpleAccent ,
                      fontWeight: FontWeight.bold,
                    )
                ),
                const SizedBox(height: 19),
                MyDropdownMenuWidget(updateGender: updateGender), // Custom dropdown → sends gender to updateGender()
                const SizedBox(height: 20),

              ],
            ),


            // ------------------ checkBox ------------------
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: isSchoolKid,
                  onChanged: (bool? value) {
                    setState(() {
                      isSchoolKid = value ?? false;
                    });
                  },
                  activeColor: Colors.deepPurpleAccent,
                ),

                const SizedBox(width: 8),
                const Text(
                    'Are you a school kid?',
                    style: const TextStyle(
                      fontSize: 20.0 ,
                      color: Colors.deepPurpleAccent ,
                      fontWeight: FontWeight.bold,
                    )
                ),


              ],
            ),
            const SizedBox(height: 20),


            // ------------------ NEXT BUTTON ------------------
            ElevatedButton(onPressed: () {
              if (_name.trim().isEmpty) { // Check if name is empty before navigating
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill the blank 💬'),
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 2),
                  ),
                );
              }else {
                // Navigate to Page2 and pass the name
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Page2(name: _name))
                );



              }
            },
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Comic Sans MS',
                  color: Colors.white,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


