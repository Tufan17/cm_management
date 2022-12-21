import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as d;
import '../../const/colors.dart';
import '../../viewModel/user_view_model.dart';

class MobileQuestion extends StatefulWidget {
  var question;
  var email;
  var userName;
  var lastName;
  var id;
  var courseTitle;

  MobileQuestion(this.question, this.email, this.userName, this.lastName,
      this.id, this.courseTitle);

  @override
  State<MobileQuestion> createState() => _MobileQuestionState();
}

class _MobileQuestionState extends State<MobileQuestion> {
  int point = 0;
  int indexQ = 0;
  List question = [];
  bool queGet = false;
  String answer = "";
  bool correctQuestion = false;
  var questionKey;
  var questionT;
  var answerKeys;
  int choice = 10;
  Map answerList;
  bool oA = false;
  bool oB = false;
  bool oC = false;
  bool oD = false;
  bool oE = false;
  List selectionList = [];
  List<String> pointList = [];

  var channel = WebSocketChannel.connect(
    Uri.parse('ws://10.14.1.81:8080'),
  );

  Future<void> getQuestion() async {
    await rootBundle.loadString("assets/question.json").then(
      (value) {
        for (int i = 0; i < value.length; i++) {
          if (json.decode(value)[i]["id"] == widget.question) {
            question = json.decode(value)[i]["question"];
            return question;
          }
        }
      },
    );
    return question;
  }

  @override
  void initState() {
    selectionList.insert(indexQ, "");
    pointList.insert(indexQ, "");

    d.log(widget.question.toString());
    waitingCheck();
    super.initState();
  }

  UserViewModel userViewModel;

  @override
  Widget build(BuildContext context) {}

  Future waitingCheck() async {
    Map<String, dynamic> map = {
      "type": "intoExam",
      "user": {
        "name": widget.userName,
        "id": widget.id,
      },
      "examID": "43"
    };
    channel.sink.add(jsonEncode(map));
  }

  Future sendPoint(var point) async {
    Map<String, dynamic> map = {
      "type": "resultExam",
      "user": {
        "name": widget.userName,
        "id": widget.id,
      },
      "point": point
    };
    channel.sink.add(jsonEncode(map));
  }

  Future getQuestions() async {
    for (int i = 0; i < 10; i++) {
      questionKey = await widget.question[0][i]["all_questions"].keys.first;
      questionT =
          await widget.question[0][i]["all_questions"][questionKey]["question"];
    }

    return questionTitle;
  }

  Widget questionTitle(Size size, Map map) {
    Map map1 = map["all_questions"];
    String key = map1.keys.toList().first.toString();
    var document = parse(map1[key]["question"].toString());
    var data = document.body.text.toString();
    var list = data.split(".");
    return Column(
      children: [
        SizedBox(
          height: size.width * 0.1,
        ),
        indexQ == 10
            ? Container(
                height: size.width * 0.2,
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: HtmlWidget(
                    list[0],
                  ),
                ),
              ),
      ],
    );
  }

  Widget questionOption(Map map, context, Size size) {
    Map map1 = map["all_questions"];
    String keyQuestion = map1.keys.toList().first.toString();

    Map keyOptions = map1[keyQuestion]["answer_options"];

    List list = keyOptions.keys.toList();

    return Column(
      children: [
        Container(
          width: size.width,
          decoration: BoxDecoration(
            color: selectionList[indexQ] == "a" ? mainColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: InkWell(
              onTap: () {
                oB = false;
                oC = false;
                oD = false;
                oE = false;

                oA = !oA; //optionAnswer
                if (oA == false) {
                  //Şık işaretleme
                  selectionList.removeAt(indexQ);
                  selectionList.insert(indexQ, "");
                  //Puan ekleme
                  pointList.removeAt(indexQ);
                  pointList.insert(indexQ, "");

                  print(pointList.toString() + " Puan");
                } else {
                  //TODO: Burada kaldık indexteki şıkkı silmek için çalışıyoduk
                  if (selectionList.isNotEmpty) {
                    print("ss");
                    selectionList.removeAt(indexQ);
                    selectionList.insert(indexQ, "a");
                    pointList.removeAt(indexQ);
                    pointList.insert(
                        indexQ, keyOptions[list[0].toString()]["marks"]);
                  } else {
                    selectionList.insert(indexQ, "a");
                    pointList.insert(
                        indexQ, keyOptions[list[0].toString()]["marks"]);
                  }
                  print(pointList.toString() + " Puan");
                }

                setState(() {});
              },
              child: Row(
                children: [
                  Text(
                    "a) ",
                    style: TextStyle(
                        color: selectionList[indexQ] == "a"
                            ? Colors.white
                            : Colors.black),
                  ),
                  Flexible(
                    child: HtmlWidget(
                      keyOptions[list[0].toString()]["value"],
                      textStyle: TextStyle(
                          color: selectionList[indexQ] == "a"
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.width * 0.1,
        ),
        Container(
          width: size.width,
          decoration: BoxDecoration(
            color: selectionList[indexQ] == "b" ? mainColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: InkWell(
              onTap: () {
                oA = false;
                oC = false;
                oD = false;
                oE = false;

                oB = !oB; //optionAnswer
                if (oB == false) {
                  selectionList.removeAt(indexQ);
                  selectionList.insert(indexQ, "");
                  pointList.removeAt(indexQ);
                  pointList.insert(indexQ, "");
                  print(pointList.toString() + " Puan");
                } else {
                  if (selectionList.isNotEmpty) {
                    selectionList.removeAt(indexQ);
                    selectionList.insert(indexQ, "b");
                    pointList.removeAt(indexQ);
                    pointList.insert(
                        indexQ, keyOptions[list[1].toString()]["marks"]);
                  } else {
                    selectionList.insert(indexQ, "b");
                    pointList.insert(
                        indexQ, keyOptions[list[1].toString()]["marks"]);
                  }
                  print(pointList.toString() + " Puan");
                }

                setState(() {});
              },
              child: Row(
                children: [
                  Text(
                    "b) ",
                    style: TextStyle(
                        color: selectionList[indexQ] == "b"
                            ? Colors.white
                            : Colors.black),
                  ),
                  Flexible(
                    child: HtmlWidget(
                      keyOptions[list[1].toString()]["value"],
                      textStyle: TextStyle(
                          color: selectionList[indexQ] == "b"
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.width * 0.1,
        ),
        Container(
          width: size.width,
          decoration: BoxDecoration(
            color: selectionList[indexQ] == "c" ? mainColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: InkWell(
              onTap: () {
                oA = false;
                oB = false;
                oD = false;
                oE = false;

                oC = !oC; //optionAnswer
                if (oC == false) {
                  selectionList.removeAt(indexQ);
                  selectionList.insert(indexQ, "");
                  pointList.removeAt(indexQ);
                  pointList.insert(indexQ, "");
                  print(pointList.toString() + " Puan");
                } else {
                  //TODO: Burada kaldık indexteki şıkkı silmek için çalışıyoduk
                  if (selectionList.isNotEmpty) {
                    print("cc");
                    selectionList.removeAt(indexQ);
                    selectionList.insert(indexQ, "c");
                    pointList.removeAt(indexQ);
                    pointList.insert(
                        indexQ, keyOptions[list[2].toString()]["marks"]);
                  } else {
                    selectionList.insert(indexQ, "c");
                    pointList.insert(
                        indexQ, keyOptions[list[2].toString()]["marks"]);
                  }
                  print(pointList.toString() + " Puan");
                }
                setState(() {});
              },
              child: Row(
                children: [
                  Text(
                    "c) ",
                    style: TextStyle(
                        color: selectionList[indexQ] == "c"
                            ? Colors.white
                            : Colors.black),
                  ),
                  Flexible(
                    child: HtmlWidget(
                      keyOptions[list[2].toString()]["value"],
                      textStyle: TextStyle(
                          color: selectionList[indexQ] == "c"
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.width * 0.1,
        ),
        Container(
          width: size.width,
          decoration: BoxDecoration(
            color: selectionList[indexQ] == "d" ? mainColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: InkWell(
              onTap: () {
                oA = false;
                oB = false;
                oC = false;
                oE = false;

                oD = !oD; //optionAnswer
                if (oD == false) {
                  selectionList.removeAt(indexQ);
                  selectionList.insert(indexQ, "");
                  pointList.removeAt(indexQ);
                  pointList.insert(indexQ, "");
                  print(pointList.toString() + " Puan");
                } else {
                  //TODO: Burada kaldık indexteki şıkkı silmek için çalışıyoduk
                  if (selectionList.isNotEmpty) {
                    print("dd");
                    selectionList.removeAt(indexQ);
                    selectionList.insert(indexQ, "d");

                    pointList.removeAt(indexQ);
                    pointList.insert(
                        indexQ, keyOptions[list[3].toString()]["marks"]);
                  } else {
                    selectionList.insert(indexQ, "d");
                    pointList.insert(
                        indexQ, keyOptions[list[3].toString()]["marks"]);
                  }
                  print(pointList.toString() + " Puan");
                }

                setState(() {});
              },
              child: Row(
                children: [
                  Text(
                    "d) ",
                    style: TextStyle(
                        color: selectionList[indexQ] == "d"
                            ? Colors.white
                            : Colors.black),
                  ),
                  Flexible(
                    child: HtmlWidget(
                      keyOptions[list[3].toString()]["value"],
                      textStyle: TextStyle(
                          color: selectionList[indexQ] == "d"
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.width * 0.1,
        ),
        Container(
          width: size.width,
          decoration: BoxDecoration(
            color: selectionList[indexQ] == "e" ? mainColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: InkWell(
              onTap: () {
                oA = false;
                oB = false;
                oC = false;
                oD = false;

                oE = !oE; //optionAnswer
                if (oE == false) {
                  selectionList.removeAt(indexQ);
                  selectionList.insert(indexQ, "");
                  pointList.removeAt(indexQ);
                  pointList.insert(indexQ, "");
                  print(pointList.toString() + " Puan");
                } else {
                  //TODO: Burada kaldık indexteki şıkkı silmek için çalışıyoduk
                  if (selectionList.isNotEmpty) {
                    print("ee");
                    selectionList.removeAt(indexQ);
                    selectionList.insert(indexQ, "e");

                    pointList.removeAt(indexQ);
                    pointList.insert(
                        indexQ, keyOptions[list[4].toString()]["marks"]);
                  } else {
                    selectionList.insert(indexQ, "e");
                    pointList.insert(
                        indexQ, keyOptions[list[4].toString()]["marks"]);
                  }
                  print(pointList.toString() + " Puan");
                }
                setState(() {});
              },
              child: Row(
                children: [
                  Text(
                    "e) ",
                    style: TextStyle(
                        color: selectionList[indexQ] == "e"
                            ? Colors.white
                            : Colors.black),
                  ),
                  Flexible(
                    child: HtmlWidget(
                      keyOptions[list[4].toString()]["value"],
                      textStyle: TextStyle(
                          color: selectionList[indexQ] == "e"
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.width * 0.09,
        ),
      ],
    );
  }

  Future getAnswers() async {
    answerKeys = await widget
        .question[0][indexQ]["all_questions"][questionKey]["answer_options"]
        .keys
        .toList();
    /*for(int i =0;i<=4 ;i++){
      answerList.addAll(widget.question[0][0]["all_questions"][questionKey]["answer_options"][answerKeys[i]]);
    }*/
    print(widget.question[0][indexQ]["all_questions"][questionKey]
        ["answer_options"][answerKeys[0]]);
    print(widget.question[0][indexQ]["all_questions"][questionKey]
        ["answer_options"][answerKeys[1]]);
    print(widget.question[0][indexQ]["all_questions"][questionKey]
        ["answer_options"][answerKeys[2]]);
    print(widget.question[0][indexQ]["all_questions"][questionKey]
        ["answer_options"][answerKeys[3]]);
    print(widget.question[0][indexQ]["all_questions"][questionKey]
        ["answer_options"][answerKeys[4]]);
  }
}
/*
*/
