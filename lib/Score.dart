import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  final int score;            // Number of correct answers
  final int totalQuestions;   // Total number of quiz questions

  const ScorePage({
    Key? key,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  // Function to generate a motivational message based on the score
  String getEncouragingMessage() {
    double percentage = (score / totalQuestions) * 100; // Convert to %

    if (percentage == 100) {
      return "🌟 Wow! Perfect Score! You're a Color Master! 🧠🎨";
    } else if (percentage >= 80) {
      return "🎉 Amazing! You really know your colors! 🌈";
    } else if (percentage >= 60) {
      return "😊 Great job! You’re getting better and better!";
    } else if (percentage >= 40) {
      return "💪 Good try! Keep practicing and you’ll shine!";
    } else {
      return "🌸 Don’t worry! Practice makes perfect! Try again! 🎨";
    }
  }

  @override
  Widget build(BuildContext context) {

    // Percent of correct answers (value between 0 and 1)
    double correctPercent = score / totalQuestions;

    // Percent of wrong answers
    double wrongPercent = 1 - correctPercent;

    return Scaffold(
      backgroundColor: Colors.purple[50],

      // Top AppBar
      appBar: AppBar(
        title: const Text(
          "🎯 Your Color Quiz Score",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),

      // Main content
      body: Center(
        child: Card(
          color: Colors.white,
          elevation: 8,  // shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // rounded corners
          ),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(30.0),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Title
                Text(
                  "Your Score:",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
                const SizedBox(height: 20),

                // 🌈 Progress bar made with a Stack
                Stack(
                  children: [

                    // Red background (wrong answer portion)
                    Container(
                      width: 250,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    // Green foreground (correct answer bar)
                    Container(
                      width: 250 * correctPercent,  // dynamic width
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Score text
                Text(
                  "$score out of $totalQuestions correct 🌸",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 25),

                // Motivational text
                Text(
                  getEncouragingMessage(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                // Button to go back to the quiz page
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // go back to previous page
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text(
                    "Back to Quiz Page",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // rounded button
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
