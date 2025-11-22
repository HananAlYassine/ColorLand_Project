import 'package:flutter/material.dart';
import 'ListView.dart';
import 'Quiz.dart';

class Page3 extends StatelessWidget {
  final String colorName;
  final Color color;

  const Page3({Key? key, required this.colorName, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    // ----------- FIND CURRENT INDEX USING FOR LOOP ------------------
    int currentIndex = 0;
    for (int i = 0; i < colorsItem.length; i++) {
      if (colorsItem[i].name == colorName) {
        currentIndex = i;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Let’s have fun learning colors today! 🖌️🌟',
          style: TextStyle(
            fontFamily: 'Comic Sans MS',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40),


          // CIRCLE
          CircleAvatar(
            radius: 100,
            backgroundColor: color,
          ),

          // COLOR NAME
          Text(
            colorName,
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Comic Sans MS',
            ),
          ),

          const SizedBox(height: 10),

          // ---------- Previous and Next Buttons For Colors --------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PREVIOUS BUTTON (Previous Color)
              ElevatedButton(
                onPressed: currentIndex == 0
                    ? null
                    : () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page3(
                        colorName: colorsItem[currentIndex - 1].name,
                        color: colorsItem[currentIndex - 1].backgroundColor,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Previous Color",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),

              const SizedBox(width: 25),

              // NEXT BUTTON (Next Color)
              ElevatedButton(
                onPressed: currentIndex == colorsItem.length - 1
                    ? null
                    : () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page3(
                        colorName: colorsItem[currentIndex + 1].name,
                        color: colorsItem[currentIndex + 1].backgroundColor,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  children: [
                    Text("Next Color",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),

          // ------------------------------------------------------
          // BOTTOM BUTTONS
          // ------------------------------------------------------
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                // ---------- PREVIOUS PAGE BUTTON --------------------------
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Go back to Page2
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text('Previous Page',
                    style: TextStyle(color: Colors.white , fontSize: 20,)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),


                // ---------- VOICE BUTTON -----------------------
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  label: const Text('Voice',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                // ---------- Quiz PAGE BUTTON ---------------
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizPage()),
                    );
                  },
                  icon: const Icon(Icons.quiz, color: Colors.white),
                  label: const Text(
                    'Quiz',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
