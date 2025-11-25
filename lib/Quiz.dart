import 'dart:math';
import 'package:flutter/material.dart';
import 'Score.dart';

// MAIN QUIZ PAGE (Stateful because answers and score will change)
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  // Stores the selected answer for each question
  // We have 3 questions → [null, null, null] means nothing selected yet
  List<dynamic> selectedAnswers = [null, null, null];

  // Final score
  int score = 0;

  // Colors map → each Color is mapped to its name as String
  final Map<Color, String> colorNames = {
    Colors.red: "Red",
    Colors.green: "Green",
    Colors.blue: "Blue",
    Colors.yellow: "Yellow",
    Colors.orange: "Orange",
    Colors.purple: "Purple",
  };

  // List that will hold 3 randomly-generated questions
  late List<QuestionModel> questions;

  @override
  void initState() {
    super.initState();
    generateRandomQuestions(); // Generate questions one time when page opens
  }

  // Function that creates 3 random questions
  void generateRandomQuestions() {
    final random = Random(); // Random generator
    final availableColors = colorNames.keys.toList(); // get the keys and convert it to list

    // Create 3 questions
    questions = List.generate(3, (index) {

      // Pick a random color from the list
      Color pickedColor = availableColors[random.nextInt(availableColors.length)];

      // Correct answer = the name of the picked color
      String correctAnswer = colorNames[pickedColor]!;

      // Pick a wrong answer (must NOT equal the correct one)
      String wrongAnswer;
      do {
        wrongAnswer = colorNames[availableColors[random.nextInt(availableColors.length)]]!;
      } while (wrongAnswer == correctAnswer);

      // Put correct + wrong answer together, then shuffle
      List<String> options = [correctAnswer, wrongAnswer]..shuffle();

      // Return a question model object
      return QuestionModel(
        shapeColor: pickedColor,
        options: options,
        correctAnswer: correctAnswer,
      );
    });
  }

  // Update selected answer for a specific question
  void updateAnswer(int index, dynamic value) {
    setState(() {
      selectedAnswers[index] = value;
    });
  }

  // Check answers and calculate score
  void calculateScore() {
    int tempScore = 0;

    for (int i = 0; i < questions.length; i++) {
      // If user's selected answer matches the correct one → add point
      if (selectedAnswers[i] == questions[i].correctAnswer) {
        tempScore++;
      }
    }

    setState(() {
      score = tempScore; // Save final score
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🎉 Color Fun Zone!",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),

      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [

            // Display all the questions (3 questions)
            for (int i = 0; i < questions.length; i++)
              QuizQuestion(
                shapeColor: questions[i].shapeColor,
                options: questions[i].options,
                selectedAnswer: selectedAnswers[i],
                onSelect: (val) => updateAnswer(i, val), // Save user choice
              ),

            const SizedBox(height: 20),

            // Button → Calculate score + go to ScorePage
            ElevatedButton(
              onPressed: () {
                calculateScore(); // Evaluate answers

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScorePage(
                      score: score,
                      totalQuestions: questions.length,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Show My Score 🏆",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MODEL that represents a single question
class QuestionModel {
  final Color shapeColor;      // The color shown in the box
  final List<String> options;  // Two answer options
  final String correctAnswer;  // The correct color name

  QuestionModel({
    required this.shapeColor,
    required this.options,
    required this.correctAnswer,
  });
}

// Widget to show ONE question
class QuizQuestion extends StatelessWidget {
  final Color shapeColor;
  final List<String> options;
  final dynamic selectedAnswer;
  final Function(dynamic) onSelect;

  const QuizQuestion({
    super.key,
    required this.shapeColor,
    required this.options,
    required this.selectedAnswer,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),

      child: Column(
        children: [

          // The colored square shown in the question
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: shapeColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black26),
            ),
          ),

          const SizedBox(height: 10),

          // List of 2 answer options (Radio buttons)
          Column(
            children: options.map((option) {
              return RadioListTile<String>(
                value: option,             // This option's value
                groupValue: selectedAnswer, // The selected answer
                onChanged: (val) => onSelect(val), // Send answer up
                title: Text(
                  option,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
