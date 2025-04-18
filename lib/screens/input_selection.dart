import 'package:csv_predictor/screens/question2.dart';
import 'package:flutter/material.dart';
import 'package:csv_predictor/widgets/drawer.dart';
import 'package:csv_predictor/widgets/feature_button.dart';

class InputSelectionScreen extends StatefulWidget {
  final Map<String, String> categoryAnswers;
  final String selectedFeature;
  final List<Map<String, dynamic>> formFields;
  final List<String> predictionOptions;

  const InputSelectionScreen({
    super.key,
    required this.categoryAnswers,
    required this.selectedFeature,
    required this.formFields,
    required this.predictionOptions,
  });

  @override
  State<InputSelectionScreen> createState() => _InputSelectionScreenState();
}

class _InputSelectionScreenState extends State<InputSelectionScreen> {
  String? selectedInput;

  void selectInput(String input) {
    setState(() {
      selectedInput = input;
    });
  }

  void navigateNext() {
    if (selectedInput == 'Manual') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QuestionFlowScreen(
          categoryAnswers: widget.categoryAnswers,
          selectedFeature: widget.selectedFeature,
          formFields: widget.formFields,
          predictionOptions: widget.predictionOptions,
          isAIMode: false,
        ),
      ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QuestionFlowScreen(
          categoryAnswers: widget.categoryAnswers,
          selectedFeature: widget.selectedFeature,
          formFields: widget.formFields,
          predictionOptions: widget.predictionOptions,
          isAIMode: true,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MenuDrawer(onFileSelected: (file) {}),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "How would you like to proceed?",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FeatureButton(
            label: "Manual",
            boxColor: selectedInput == "Manual" ? Colors.black : Colors.white,
            textColor: selectedInput == "Manual" ? Colors.white : Colors.black,
            onTap: () => selectInput("Manual"),
          ),
          FeatureButton(
            label: "AI Assisted",
            boxColor:
                selectedInput == "AI Assisted" ? Colors.black : Colors.white,
            textColor:
                selectedInput == "AI Assisted" ? Colors.white : Colors.black,
            onTap: () => selectInput("AI Assisted"),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            decoration:
                const BoxDecoration(color: Color.fromARGB(96, 172, 154, 154)),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                IconButton(
                  onPressed: selectedInput != null ? navigateNext : null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: selectedInput != null ? Colors.black : Colors.grey,
                  ),
                  tooltip: selectedInput != null
                      ? "Go Forward"
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
