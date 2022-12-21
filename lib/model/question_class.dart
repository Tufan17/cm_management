import 'dart:convert';

Sorular sorularFromMap(String str) => Sorular.fromMap(json.decode(str));

String sorularToMap(Sorular data) => json.encode(data.toMap());

class Sorular {
  Sorular({
    this.name,
    this.question,
  });

  final String name;
  final List<Question> question;

  factory Sorular.fromMap(Map<String, dynamic> json) => Sorular(
        name: json["name"],
        question: List<Question>.from(
            json["question"].map((x) => Question.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "question": List<dynamic>.from(question.map((x) => x.toMap())),
      };
}

class Question {
  Question({
    this.id,
    this.time,
    this.title,
    this.answerOptions,
  });

  final String id;
  final String time;
  final String title;
  final List<AnswerOption> answerOptions;

  factory Question.fromMap(Map<String, dynamic> json) => Question(
        id: json["id"],
        time: json["time"],
        title: json["title"],
        answerOptions: List<AnswerOption>.from(
            json["answer_options"].map((x) => AnswerOption.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "time": time,
        "title": title,
        "answer_options":
            List<dynamic>.from(answerOptions.map((x) => x.toMap())),
      };
}

class AnswerOption {
  AnswerOption({
    this.value,
    this.marks,
  });

  final String value;
  final bool marks;

  factory AnswerOption.fromMap(Map<String, dynamic> json) => AnswerOption(
        value: json["value"],
        marks: json["marks"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "marks": marks,
      };
}
