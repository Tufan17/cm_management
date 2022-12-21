import 'package:flutter/material.dart';

import '../../const/colors.dart';
import '../../services/db_services.dart';
import 'dart:developer'as d;

class QuestionView extends StatefulWidget {
  int courseId;
  QuestionView(this.courseId);
  @override
  State<QuestionView> createState() => _QuestionViewState();
}


class _QuestionViewState extends State<QuestionView> {
  DBService dbService = DBService();
  int subjectId;

  @override
  void initState() {
    getCourseSubject(widget.courseId).then((value) {

      getCourseSubjectQuestion(value[0]["id"]).then((values) {
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding:  EdgeInsets.only(right:20.0),
            child: Row(
              children: [
                Text(
                  "qr",
                  style: TextStyle(
                      color: mainColor,
                      fontSize: size.width * 0.02,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Exam",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * 0.02,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
        leading: SizedBox(
          height: size.width*0.02,
          width: size.width*0.02,
          child: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            hoverColor: Colors.grey[100],
            padding: new EdgeInsets.all(0.0),
            color: mainColor,
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: FutureBuilder(
          future: getCourseSubject(widget.courseId),
          builder: (context,async){
            if(async.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }else{
              return TextButton(onPressed: (){
                d.log(async.data.toString());
              }, child: Text("asdasd"));
            }
          },
        ),
      ),
    );
  }
  Future getCourseSubject(int id) async {
    var subject = await dbService.getCourseSubject(id);
    return subject;
  }
  Future getCourseSubjectQuestion(int id) async {
    var questions = await dbService.getCourseSubjectQuestion(id);
    return questions;
  }
}
