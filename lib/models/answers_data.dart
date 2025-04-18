class AnswersData {
  final List<Map<String, String>> answers;

  AnswersData({required this.answers});

  factory AnswersData.fromMap(Map<String, String> answersMap) {
    List<Map<String, String>> formatted = [];
    answersMap.forEach((key, value) {
      formatted.add({key: value});
    });
    return AnswersData(answers: formatted);
  }

  Map<String, String> toMap() {
    Map<String, String> result = {};
    for (var answer in answers) {
      result.addAll(answer);
    }
    return result;
  }

  List<Map<String, String>> toJson() => answers;
}
