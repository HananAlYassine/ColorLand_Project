import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ---------------- HISTORY PAGE WIDGET ----------------
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

// --------------------------------------------------
  // This function groups quiz history by child name
  // Input: List of quiz records from the API
  // Output: Map where:
  //   key   = child name
  //   value = list of quizzes for that child
// --------------------------------------------------

  Map<String, List<dynamic>> groupByChild(List data) {
    final Map<String, List<dynamic>> grouped = {};
    // Loop over each quiz record
    for (var item in data) {

      // If the child's name does not exist in the map,
      // create a new empty list for it
      grouped.putIfAbsent(item['name'], () => []);

      // Add this quiz record to the child's list
      grouped[item['name']]!.add(item);
    }
    return grouped;
  }



// --------------------------------------------------
  // Function to fetch quiz history from the backend
  // Uses HTTP GET request to a PHP API
  // Returns a List of quiz records
// ---------------------------------------------------
  Future<List> fetchHistory() async {
    final String url = "http://hananalyassine.atwebpages.com/get_history.php";
    try {
      // Send GET request to the API
      final res = await http.get(Uri.parse(url));
      // If request is successful
      if (res.statusCode == 200) {
        // Decode JSON response into Dart List
        return json.decode(res.body);
      } else {
        // If server error, return empty list
        return [];
      }
    } catch (e) {
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🏆 Score History", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      // ==================== Page Body =========================
      body: Container(
        color: const Color(0xfffce4ec), // Light pink background
        // FutureBuilder waits for fetchHistory() to finish
        child: FutureBuilder(
          future: fetchHistory(),
          builder: (context, snapshot) {
            // While data is loading → show spinner
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // If no data returned → show message
            if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
              return const Center(
                child: Text("No history yet. Go take a quiz!",
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              );
            }

            // ---------- DATA PROCESSING ----------
            final rawData = snapshot.data as List;
            // Group quizzes by child name
            final groupedData = groupByChild(rawData);
            // Extract child names from the map
            final childrenNames = groupedData.keys.toList();

            // ---------- LIST VIEW ----------
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: childrenNames.length,
              itemBuilder: (context, index) {
                final name = childrenNames[index]; // Child name
                final quizzes = groupedData[name]!; // Child quizzes list

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---------- CHILD NAME ROW ----------
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.deepPurpleAccent,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 10),

                            // Display child name
                            Text(
                              name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // ---------- QUIZZES LIST ----------
                        // Loop over each quiz and display it
                        ...quizzes.asMap().entries.map((entry) {
                          final i = entry.key + 1;
                          final quiz = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(left: 10, top: 4),
                            child: Text(
                              // Show quiz score, total questions, and date
                              "Quiz $i : Score ${quiz['score']} / ${quiz['total_questions']} at ${quiz['created_at']}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            );

          },
        ),
      ),
    );
  }
}