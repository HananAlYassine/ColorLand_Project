import 'package:flutter/material.dart';

// This widget represents ONE quiz question.
// It shows:
// - Question text
// - Optional color box (if showColorBox is true)
// - Multiple choice options (radio buttons)
// - Checkmark or X after answering
// - Sends result (correct/wrong) to parent using onAnswered
class ColorQuestionWidget extends StatefulWidget {

  final List<String> options;      // List of multiple-choice answers
  final String correctAnswer;      // The correct answer for this question
  final Function(bool) onAnswered; // Callback to parent: true = correct, false = wrong
  final Color? color;              // Optional color to display in a box
  final bool showColorBox;         // Whether to show a color box above the question

  const ColorQuestionWidget({
    super.key,
    required this.options,
    required this.correctAnswer,
    required this.onAnswered,
    this.color,
    this.showColorBox = false,     // Default: do not show the color box
  });

  @override
  State<ColorQuestionWidget> createState() => _ColorQuestionWidgetState();
}

class _ColorQuestionWidgetState extends State<ColorQuestionWidget> {

  String? selectedOption; // Stores which answer the user selected
  bool answered = false; // Prevents the user from changing answer after selecting

  // This function is called when the user selects an answer
  void checkAnswer(String value) {
    if (answered) return; // If already answered, do nothing

    setState(() {
      selectedOption = value; // Save selected answer
      answered = true;        // Lock the question (disable future taps)
    });

    // Notify parent widget whether user answered correctly
    widget.onAnswered(value == widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      elevation: 4, // Shadow effect
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      child: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Show the color square ONLY if:
            // - showColorBox is true
            // - color is provided
            if (widget.showColorBox && widget.color != null) ...[
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: widget.color,       // The color to display
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black26, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],


            const SizedBox(height: 10),

            // Display multiple-choice answers (radio buttons)
            Column(
              children: widget.options.map((option) {

                return RadioListTile<String>(
                  title: Text(
                    option, // Show the option text
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),

                  value: option,              // Each option has a unique value
                  groupValue: selectedOption, // The selected one gets highlighted

                  activeColor: Colors.purpleAccent, // Color of the selected radio

                  onChanged: (value) {
                    // Only allow answering once
                    if (!answered) checkAnswer(value!);
                  },
                );

              }).toList(),
            ),

          ],
        ),
      ),
    );
  }
}
