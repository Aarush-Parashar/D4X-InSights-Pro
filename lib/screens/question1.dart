import 'package:flutter/material.dart';
import 'package:csv_predictor/widgets/drawer.dart';
import 'package:csv_predictor/widgets/feature_button.dart';

class QuestionScreen extends StatefulWidget {
  final List<String> categories;
  final Map<String, String> answers;
  final Function(Map<String, String>)? onComplete;

  const QuestionScreen({
    super.key,
    required this.categories,
    required this.answers,
    this.onComplete,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentIndex = 0;
  Map<String, String> currentAnswers = {};

  @override
  void initState() {
    super.initState();
    currentAnswers = Map<String, String>.from(widget.answers);
  }

  void selectAnswer(String answer) {
    setState(() {
      currentAnswers[widget.categories[currentIndex]] = answer;
    });
  }

  void navigateNext() {
    if (currentIndex < widget.categories.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      widget.onComplete?.call(currentAnswers);
    }
  }

  void navigateBack() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String categoryName = widget.categories[currentIndex];
    final bool isLastCategory = currentIndex == widget.categories.length - 1;
    final String? selectedAnswer = currentAnswers[categoryName];
    final int progress = currentIndex + 1;
    final int total = widget.categories.length;

    return Scaffold(
      appBar: AppBar(),
      drawer: MenuDrawer(onFileSelected: (file) {}),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: progress / total,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Is $categoryName a category?",
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FeatureButton(
            label: "Yes",
            boxColor: selectedAnswer == "Yes" ? Colors.black : Colors.white,
            textColor: selectedAnswer == "Yes" ? Colors.white : Colors.black,
            onTap: () => selectAnswer("Yes"),
          ),
          FeatureButton(
            label: "No",
            boxColor: selectedAnswer == "No" ? Colors.black : Colors.white,
            textColor: selectedAnswer == "No" ? Colors.white : Colors.black,
            onTap: () => selectAnswer("No"),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            decoration:
                const BoxDecoration(color: Color.fromARGB(96, 172, 154, 154)),
            child: Row(
              children: [
                IconButton(
                  onPressed: navigateBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                IconButton(
                  onPressed: selectedAnswer != null ? navigateNext : null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: selectedAnswer != null ? Colors.black : Colors.grey,
                  ),
                  tooltip: selectedAnswer != null
                      ? isLastCategory
                          ? "Complete"
                          : "Next Question"
                      : "Please select an option first",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
