class QuestionData {
  final Map<String, List<String>> questionsWithOptions;

  QuestionData({required this.questionsWithOptions});

  factory QuestionData.fromQuestionsList(List<Map<String, dynamic>> questions) {
    Map<String, List<String>> formatted = {};
    for (var question in questions) {
      formatted[question['question']] = List<String>.from(question['options']);
    }
    return QuestionData(questionsWithOptions: formatted);
  }

  Map<String, dynamic> toJson() => questionsWithOptions;
  List<MapEntry<String, List<String>>> get questionsList =>
      questionsWithOptions.entries.toList();
}
