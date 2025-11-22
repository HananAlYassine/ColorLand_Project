import 'package:flutter/material.dart';

class ColorQuestionWidget extends StatefulWidget {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final Function(bool) onAnswered;
  final Color? color;
  final bool showColorBox;

  const ColorQuestionWidget({
    super.key,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.onAnswered,
    this.color,
    this.showColorBox = false,
  });

  @override
  State<ColorQuestionWidget> createState() => _ColorQuestionWidgetState();
}

class _ColorQuestionWidgetState extends State<ColorQuestionWidget> {
  String? selectedOption;
  bool answered = false;

  void checkAnswer(String value) {
    if (answered) return;
    setState(() {
      selectedOption = value;
      answered = true;
    });
    widget.onAnswered(value == widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (widget.showColorBox && widget.color != null) ...[
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black26, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],

            Text(
              widget.questionText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),


            Column(
              children: widget.options.map((option) {
                return RadioListTile<String>(
                  title: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  value: option,
                  groupValue: selectedOption,
                  activeColor: Colors.purpleAccent,
                  onChanged: (value) {
                    if (!answered) checkAnswer(value!);
                  },
                );
              }).toList(),
            ),

            if (answered)
              Center(
                child: Icon(
                  selectedOption == widget.correctAnswer
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: selectedOption == widget.correctAnswer
                      ? Colors.green
                      : Colors.red,
                  size: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
