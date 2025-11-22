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

  void updateAnswer(int index, dynamic value) {
    setState(() {
      selectedAnswers[index] = value;
    });
  }

  void calculateScore() {
    List<dynamic> correctAnswers = ["Red", "Green", "🌞"];
    int tempScore = 0;
    for (int i = 0; i < correctAnswers.length; i++) {
      if (selectedAnswers[i] == correctAnswers[i]) tempScore++;
    }
    setState(() {
      score = tempScore;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎉 Color Fun Zone!" ,
          style: TextStyle(
              fontWeight: FontWeight.bold ,
              color: Colors.white),),

        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: Colors.white,
      body:
      SingleChildScrollView(

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            QuizQuestion(
              shapeColor: Colors.red,
              options: ["Red", "Blue"],
              selectedAnswer: selectedAnswers[0],
              onSelect: (val) => updateAnswer(0, val),
            ),


            QuizQuestion(
              shapeColor: Colors.green,
              options: ["Yellow", "Green"],
              selectedAnswer: selectedAnswers[1],
              onSelect: (val) => updateAnswer(1, val),
            ),


            QuizQuestion(
              questionText: " Which one is YELLOW? 💛 ",
              options: ["🌞", "☘️"],
              selectedAnswer: selectedAnswers[2],
              onSelect: (val) => updateAnswer(2, val),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                calculateScore();
                // When pressed, navigate to the Score Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScorePage(
                      score: score,
                      totalQuestions: selectedAnswers.length,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:Colors.deepPurpleAccent,
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Show My Score 🏆",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,
                color: Colors.white),
              ),
            ),
          ],
        ),
      ),

    );
  }
}

class QuizQuestion extends StatelessWidget {
  final Color? shapeColor;
  final String? questionText;
  final List<String> options;
  final dynamic selectedAnswer;
  final Function(dynamic) onSelect;

  const QuizQuestion({
    super.key,
    this.shapeColor,
    this.questionText,
    required this.options,
    this.selectedAnswer,
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

          if (shapeColor != null)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: shapeColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black26)),
            ),
          if (questionText != null)
            Text(
              questionText!,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
