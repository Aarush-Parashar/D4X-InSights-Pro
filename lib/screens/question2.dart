import 'package:csv_predictor/screens/forcast_screen.dart';
import 'package:flutter/material.dart';
import 'package:csv_predictor/screens/visualizations.dart';
import 'package:csv_predictor/widgets/drawer.dart';
import 'package:csv_predictor/widgets/feature_button.dart';
import 'package:csv_predictor/screens/unseen_data.dart';

class QuestionFlowScreen extends StatefulWidget {
  final Map<String, String> categoryAnswers;
  final String selectedFeature;
  final List<Map<String, dynamic>> formFields;
  final List<String> predictionOptions;
  final bool isAIMode;
  final Map<String, double>? modelOptions;

  const QuestionFlowScreen({
    super.key,
    required this.categoryAnswers,
    required this.selectedFeature,
    required this.formFields,
    required this.predictionOptions,
    required this.isAIMode,
    this.modelOptions,
  });

  @override
  State<QuestionFlowScreen> createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen> {
  int currentQuestionIndex = 0;
  Map<String, String> answers = {};
  String? selectedOption;
  late List<Map<String, dynamic>> questions;

  @override
  void initState() {
    super.initState();
    // Initialize questions based on mode
    if (widget.isAIMode) {
      questions = [
        {
          'question': 'What do you want to ${widget.selectedFeature}?',
          'options': widget.predictionOptions,
          'key': 'target'
        },
      ];
    } else {
      // Get model options from backend or use defaults
      List<String> modelOptionStrings = [];
      if (widget.modelOptions != null && widget.modelOptions!.isNotEmpty) {
        modelOptionStrings = widget.modelOptions!.entries
            .map((entry) => "${entry.key} (${entry.value.toStringAsFixed(2)}%)")
            .toList();
      } else {
        modelOptionStrings = [
          'Linear Regression',
          'Logistic Regression',
          'Ridge Regression'
        ];
      }

      // All questions for manual mode
      questions = [
        {
          'question': 'Replace Numerical missing\nvalues with',
          'options': ['Median', 'Mean'],
          'key': 'numerical'
        },
        {
          'question': 'Replace Categorical missing\nvalues with',
          'options': ['Mode', 'Previous Value'],
          'key': 'categorical'
        },
        {
          'question': 'Choose the intensity to\nremove the outliers',
          'options': ['Low', 'Medium', 'High'],
          'key': 'outliers'
        },
        {
          'question': 'Which encoding method\ndo you want to use?',
          'options': ['Label', 'Frequency', 'Ordinal'],
          'key': 'encoding'
        },
        {
          'question': 'How do you want to do the feature scaling?',
          'options': ['Normalization', 'Standardization'],
          'key': 'scaling'
        },
        {
          'question': 'What do you want to ${widget.selectedFeature}?',
          'options': widget.predictionOptions,
          'key': 'target'
        },
        {
          'question': 'Do you want to choose the ML model?',
          'options': ['Yes', 'No'],
          'key': 'choose_model'
        },
        {
          'question': 'Select a ML model?',
          'options': modelOptionStrings,
          'key': 'model'
        },
      ];
    }
  }

  // Extract model name without accuracy percentage for saving to answers
  String extractModelName(String optionWithAccuracy) {
    if (optionWithAccuracy.contains(' (')) {
      return optionWithAccuracy.split(' (')[0];
    }
    return optionWithAccuracy;
  }

  void navigateToFinalScreen() {
    switch (widget.selectedFeature) {
      case 'Predict':
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UnseenDataScreen(formFields: widget.formFields),
        ));
        break;
      case 'Forecast':
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ForcastScreen(),
        ));
        break;
      case 'Visualize':
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const VisualizationsScreen(),
        ));
        break;
    }
  }

  void navigateNext() {
    if (selectedOption != null) {
      // For the model selection, extract the model name without accuracy
      if (questions[currentQuestionIndex]['key'] == 'model') {
        answers[questions[currentQuestionIndex]['key']] =
            extractModelName(selectedOption!);
      } else {
        answers[questions[currentQuestionIndex]['key']] = selectedOption!;
      }
    }

    if (widget.isAIMode) {
      // For AI mode, go directly to final screen after target selection
      navigateToFinalScreen();
      return;
    }

    // Handle navigation for manual mode
    if (widget.selectedFeature == 'Visualize') {
      if (answers['outliers'] != null) {
        navigateToFinalScreen();
        return;
      }
    } else if (widget.selectedFeature == 'Forecast') {
      if (currentQuestionIndex >= 5) {
        // After answering target question
        navigateToFinalScreen();
        return;
      }
    } else if (widget.selectedFeature == 'Predict') {
      if (currentQuestionIndex < questions.length - 1) {
        if (currentQuestionIndex == 6 && answers['choose_model'] == 'No') {
          navigateToFinalScreen();
          return;
        }
        setState(() {
          currentQuestionIndex++;
          selectedOption = answers[questions[currentQuestionIndex]['key']];
        });
      } else {
        navigateToFinalScreen();
        return;
      }
    }

    // Move to next question if we haven't navigated away
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = answers[questions[currentQuestionIndex]['key']];
      });
    }
  }

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAIMode) {
      // Get maximum questions based on selected feature for manual mode
      int maxQuestions;
      switch (widget.selectedFeature) {
        case 'Visualize':
          maxQuestions = 3; // Up to outliers
          break;
        case 'Forecast':
          maxQuestions = 6; // Up to target selection
          break;
        case 'Predict':
        default:
          maxQuestions = questions.length;
          break;
      }

      if (currentQuestionIndex >= maxQuestions) {
        navigateToFinalScreen();
        return Container();
      }
    }

    final currentQuestion = questions[currentQuestionIndex];

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
            child: Text(
              currentQuestion['question'],
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...currentQuestion['options'].map((option) => FeatureButton(
                label: option,
                boxColor:
                    selectedOption == option ? Colors.black : Colors.white,
                textColor:
                    selectedOption == option ? Colors.white : Colors.black,
                onTap: () => selectOption(option),
              )),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            decoration:
                const BoxDecoration(color: Color.fromARGB(96, 172, 154, 154)),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (currentQuestionIndex > 0) {
                      setState(() {
                        currentQuestionIndex--;
                        selectedOption =
                            answers[questions[currentQuestionIndex]['key']];
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(flex: 2),
                IconButton(
                  onPressed: selectedOption != null ? navigateNext : null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: selectedOption != null ? Colors.black : Colors.grey,
                  ),
                  tooltip: selectedOption != null
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
