import 'dart:math';
import 'package:flutter/material.dart';
import 'Score.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}


class _QuizPageState extends State<QuizPage> {

  List<dynamic> selectedAnswers = [null, null, null];
  int score = 0;

  final Map<Color, String> colorNames = {
    Colors.red: "Red",
    Colors.green: "Green",
    Colors.blue: "Blue",
    Colors.yellow: "Yellow",
    Colors.orange: "Orange",
    Colors.purple: "Purple",
  };

  late List<QuestionModel> questions;

  @override
  void initState() {
    super.initState();
    generateRandomQuestions();
  }

  void generateRandomQuestions() {
    final random = Random();
    final availableColors = colorNames.keys.toList();

    questions = List.generate(3, (index) {
      // random rectangle color
      Color pickedColor = availableColors[random.nextInt(availableColors.length)];
      String correctAnswer = colorNames[pickedColor]!;

      // create options list containing correct answer & one random wrong answer
      String wrongAnswer;
      do {
        wrongAnswer = colorNames[availableColors[random.nextInt(availableColors.length)]]!;
      } while (wrongAnswer == correctAnswer);

      // shuffle options
      List<String> options = [correctAnswer, wrongAnswer]..shuffle();

      return QuestionModel(
        shapeColor: pickedColor,
        options: options,
        correctAnswer: correctAnswer,
      );
    });
  }

  void updateAnswer(int index, dynamic value) {
    setState(() {
      selectedAnswers[index] = value;
    });
  }

  void calculateScore() {
    int tempScore = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswer) {
        tempScore++;
      }
    }
    setState(() {
      score = tempScore;
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
            for (int i = 0; i < questions.length; i++)
              QuizQuestion(
                shapeColor: questions[i].shapeColor,
                options: questions[i].options,
                selectedAnswer: selectedAnswers[i],
                onSelect: (val) => updateAnswer(i, val),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                calculateScore();
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
                    borderRadius: BorderRadius.circular(12)),
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

class QuestionModel {
  final Color shapeColor;
  final List<String> options;
  final String correctAnswer;

  QuestionModel({
    required this.shapeColor,
    required this.options,
    required this.correctAnswer,
  });
}

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

          Column(
            children: options.map((option) {
              return RadioListTile<String>(
                value: option,
                groupValue: selectedAnswer,
                onChanged: (val) => onSelect(val),
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
