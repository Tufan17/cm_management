import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../const/api_const.dart';
import '../../const/colors.dart';
import '../../services/db_services.dart';
import '../../viewModel/user_view_model.dart';
import 'package:http/http.dart' as http;

import 'attendance_lesson.dart';
import 'desktop_timer_view.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  DBService dbService = DBService();
  UserViewModel userViewModel;
  List exam = [];
  bool data = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExams().then((value) {
      setState(() {
        data = true;
        exam = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Yoklama",
          style: TextStyle(
              color: Colors.black45,
              fontSize: size.width * 0.02,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: mainColor,
          ),
        ),
        actions: [
          Image.asset(
            "assets/cm-logo.png",
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: data == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: exam.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: (2 / 2),
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: AttendanceLesson(name: exam[index]["name"]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 400,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                      child: Column(
                        children: [
                          Expanded(child: Image.asset("assets/login.png")),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              exam[index]["name"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * 0.015,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }

  Future getExams() async {
    final response = await http.get(
      Uri.parse(companyUrl + '/api/lessons'),
      headers: {'Accept': 'application/json', 'Cookie': loginCookie},
    );
    var question = json.decode(response.body);

    return question;
  }
}
