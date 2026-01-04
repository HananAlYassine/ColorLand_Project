import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Score.dart';

// ===========
// QUIZ PAGE
// ============
class QuizPage extends StatefulWidget {
  final int childId;

  const QuizPage({super.key,
    required this.childId,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // List that stores questions fetched from the database
  List questions = [];

  // Stores the selected answer for each question
  List selectedAnswers = [];

  // Variable that stores the final score
  int score = 0;

  // URL of the PHP file
  final String url = "http://hananalyassine.atwebpages.com/get_questions.php";

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  // ==============================
  // FETCH QUESTIONS FROM DATABASE
  // ===============================
  Future<void> fetchQuestions() async {
    try {
      // 1. Send GET request with a timeout
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        // 2. Decode JSON response
        final data = json.decode(res.body);

        // 3. Check if we actually got a list (and not an error message)
        if (data is List) {
          setState(() {
            questions = data;
            // Initialize selected answers list with null values
            selectedAnswers = List.filled(data.length, null);
          });
        } else if (data is Map && data.containsKey('error')) {
          _showError("Server Error: ${data['error']}");
        }
      } else {
        _showError("Failed to connect to server (Code: ${res.statusCode})");
      }
    } catch (e) {
      debugPrint("Quiz Error: $e");
      _showError("Check your internet connection or CORS settings.");
    }
  }

  // Helper to show errors
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // =====================
  // CALCULATE QUIZ SCORE
  // =====================
  void calculateScore() {
    score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['correct']) {
        score++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // While questions are loading
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepPurpleAccent),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Loading your Quiz... 🎨"),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🎉 Color Fun Zone!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Loop through all quiz questions
            for (int i = 0; i < questions.length; i++)
              Card(
                margin: const EdgeInsets.only(bottom: 20),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text("Question ${i + 1}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      // Display the colored square
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(
                              questions[i]['color'].replaceFirst("#", "0xff"),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Display answer options
                      for (var opt in questions[i]['options'])
                        RadioListTile(
                          value: opt,
                          groupValue: selectedAnswers[i],
                          activeColor: Colors.deepPurpleAccent,
                          onChanged: (val) {
                            setState(() {
                              selectedAnswers[i] = val;
                            });
                          },
                          title: Text(opt, style: const TextStyle(fontSize: 18)),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Button to calculate score
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Ensure all questions are answered
                  if (selectedAnswers.contains(null)) {
                    _showError("Please answer all questions first!");
                    return;
                  }

                  calculateScore();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScorePage(
                        score: score,
                        totalQuestions: questions.length,

                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Show My Score 🏆",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}