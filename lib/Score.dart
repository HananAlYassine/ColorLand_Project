import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'History.dart';
import 'global.dart';

class ScorePage extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ScorePage({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  bool _isSaved = false;
  String _status = "Saving to database...";

  @override
  void initState() {
    super.initState();
    saveResult();
  }

  Future<void> saveResult() async {
    if (_isSaved) return;

    try {
      final response = await http.post(
        Uri.parse("http://hananalyassine.atwebpages.com/save_quiz.php"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "child_id": globalChildId.toString(),
          "score": widget.score.toString(),
          "total_questions": widget.totalQuestions.toString(),
        },
      );

      if (response.statusCode == 200 && response.body.contains("success")) {
        setState(() {
          _isSaved = true;
          _status = "Result saved successfully! ✅";
        });
        print("Database Updated!");
      } else {
        setState(() {
          _status = "Error: Could not save result.";
        });
        print("Server Error: ${response.body}");
      }
    } catch (e) {
      setState(() {
        _status = "Network Error. Please try again.";
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double percent = widget.totalQuestions > 0 ? widget.score / widget.totalQuestions : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎯 Your Color Quiz Score",
            style: TextStyle(color: Colors.white)

        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false, // Prevents going back to the quiz
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display Score
              Text(
                "Score: ${widget.score} / ${widget.totalQuestions}",
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 30,
                  backgroundColor: Colors.grey[300],
                  color: Colors.orangeAccent,
                ),
              ),

              const SizedBox(height: 20),

              // Status message to show if saving worked
              Text(
                _status,
                style: TextStyle(
                  color: _isSaved ? Colors.green : Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 40),

              // Button to go to History
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryPage()),
                  );
                },
                icon: const Icon(Icons.history, color: Colors.white),
                label: const Text("View History", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),

              const SizedBox(height: 20),

              // Button to go Home
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text("Play Again", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}