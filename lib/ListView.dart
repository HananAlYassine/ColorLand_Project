import 'package:flutter/material.dart';
import 'Colors.dart';

// CLASS THAT REPRESENTS A COLOR ITEM
class ColorItem {
  final String name;
  final Color backgroundColor;
  final Color color;

  ColorItem(this.name, this.backgroundColor, this.color);
}

// LIST OF COLORS TO DISPLAY IN THE LISTVIEW
List<ColorItem> colorsItem = [
  ColorItem('Red', Colors.red, Colors.white),
  ColorItem('Blue', Colors.blue, Colors.white),
  ColorItem('Yellow', Colors.yellow, Colors.black),
  ColorItem('Green', Colors.green, Colors.white),
  ColorItem('Orange', Colors.orange, Colors.white),
  ColorItem('Purple', Colors.purple, Colors.white),
  ColorItem('Black', Colors.black, Colors.white),
  ColorItem('White', Colors.white, Colors.black),
  ColorItem('Brown', Colors.brown, Colors.white),
];

// PAGE2 — DISPLAYS LIST OF COLORS
class Page2 extends StatelessWidget {

  final String name; // The child's name passed from HomePage
  const Page2({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE9E7), // light pink background
      appBar: AppBar(
        title: Text(
          'Welcome $name ✨',  // Dynamic title with child name
        style: const TextStyle(
            fontFamily: 'Comic Sans MS',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),


      body: Column(
        children: [
          Expanded( // It forces the child to expand and fill the empty space around it.
            // Let the ListView take all the remaining height on the screen
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              itemCount: colorsItem.length, // Number of colors in list
              itemBuilder: (context, index) {
                final color = colorsItem[index]; // Current color item
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 90,   // Height of each box
                  decoration: BoxDecoration(
                    color: color.backgroundColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),

                    // Center text inside the box
                      child: Center(
                      child: ListTile(
                        title: Text(
                          color.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: color.color,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Comic Sans MS',
                          ),
                        ),
                        // When user taps a color item
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Page3(
                                colorName: color.name, // Pass color name
                                color: color.backgroundColor,  // Pass color value
                              ),
                            ),
                          );
                        },
                      ),
                      )
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Back Button
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.deepPurpleAccent,
          //         foregroundColor: Colors.white,
          //         shape: const CircleBorder(),
          //         padding: const EdgeInsets.all(16),
          //       ),
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //       },
          //       child: const Icon(Icons.navigate_before, size: 40),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 20),
        ],
      ),


    );
  }
}
