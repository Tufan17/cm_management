import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/db_services.dart';
import '../../viewModel/user_view_model.dart';
import 'desktop_courses_view.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({Key key}) : super(key: key);

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  DBService dbService = DBService();
  UserViewModel userViewModel;
  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Sınavlar",
          style: TextStyle(
              color: Colors.black45,
              fontSize: size.width * 0.02,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Image.asset(
            "assets/cm-logo.png",
            scale: 3,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DesktopCourses()));
                },
                child: Container(
                  height: 400,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    children: [
                      Expanded(child: Image.asset("assets/online_lesson.png")),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ders",
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
              Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Column(
                  children: [
                    Expanded(child: Image.asset("assets/exam.png")),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Sınav",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.015,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Column(
                  children: [
                    Expanded(child: Image.asset("assets/register.png")),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Yoklama",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.015,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
