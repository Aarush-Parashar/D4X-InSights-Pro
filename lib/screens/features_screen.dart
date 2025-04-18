import 'package:csv_predictor/screens/input_selection.dart';
import 'package:flutter/material.dart';
import 'package:csv_predictor/screens/question1.dart';
import 'package:csv_predictor/widgets/drawer.dart';
import 'package:csv_predictor/widgets/feature_button.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  String? selectedFeature;

  void selectFeature(String feature) {
    setState(() {
      selectedFeature = feature;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Features",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
        ),
      ),
      drawer: MenuDrawer(onFileSelected: (file) {}),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "What do you want to do with the Data?",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FeatureButton(
            label: "Visualize",
            boxColor:
                selectedFeature == "Visualize" ? Colors.black : Colors.white,
            textColor:
                selectedFeature == "Visualize" ? Colors.white : Colors.black,
            onTap: () => selectFeature("Visualize"),
          ),
          FeatureButton(
            label: "Predict",
            boxColor:
                selectedFeature == "Predict" ? Colors.black : Colors.white,
            textColor:
                selectedFeature == "Predict" ? Colors.white : Colors.black,
            onTap: () => selectFeature("Predict"),
          ),
          FeatureButton(
            label: "Forecast",
            boxColor:
                selectedFeature == "Forecast" ? Colors.black : Colors.white,
            textColor:
                selectedFeature == "Forecast" ? Colors.white : Colors.black,
            onTap: () => selectFeature("Forecast"),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            decoration:
                const BoxDecoration(color: Color.fromARGB(96, 172, 154, 154)),
            child: Row(
              children: [
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                IconButton(
                  onPressed: selectedFeature != null
                      ? () {
                          final List<String> categories = [
                            "SALES",
                            "DISCOUNT",
                            "COUNTRY NAME"
                          ];
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => QuestionScreen(
                              categories: categories,
                              answers: {},
                              onComplete:
                                  (Map<String, String> categoryAnswers) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => InputSelectionScreen(
                                    categoryAnswers: categoryAnswers,
                                    selectedFeature: selectedFeature!,
                                    predictionOptions: [
                                      'Sales',
                                      'Profit',
                                      'Revenue'
                                    ],
                                    formFields: [
                                      {
                                        "name": "Sales",
                                        "inputtype": "Number",
                                        "placeholder": "Enter a Number value",
                                      },
                                      {
                                        "name": "Country",
                                        "inputtype": "Dropdown",
                                        "placeholder": "India",
                                        "values": [
                                          "India",
                                          "America",
                                          "New Zealand",
                                          "Africa",
                                          "korea"
                                        ],
                                      },
                                      {
                                        "name": "Discount",
                                        "inputtype": "Number",
                                        "placeholder":
                                            "Enter a Number value between 0 to 90",
                                      },
                                    ],
                                  ),
                                ));
                              },
                            ),
                          ));
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: selectedFeature != null ? Colors.black : Colors.grey,
                  ),
                  tooltip: selectedFeature != null
                      ? "Go Forward"
                      : "Please select a feature first",
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Center(
              child: Text(
                "What Task do you want to perform?",
                style: TextStyle(
                  color: Color.fromARGB(96, 172, 154, 154),
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
