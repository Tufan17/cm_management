import 'package:cm_flutter/view/desktop/attendance.dart';
import 'package:cm_flutter/view/desktop/exam.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/db_services.dart';
import '../../viewModel/user_view_model.dart';
import 'desktop_courses_view.dart';

class ChooseScreens extends StatefulWidget {
  const ChooseScreens({Key key}) : super(key: key);

  @override
  State<ChooseScreens> createState() => _ChooseScreensState();
}

class _ChooseScreensState extends State<ChooseScreens> {
  DBService dbService = DBService();
  UserViewModel userViewModel;
  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Hoşgeldiniz",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: size.width * 0.02,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${userViewModel.userModel.name}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.02,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/cm-logo.png",
                  scale: 3,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Yapmak istediğiniz işlemi seçiniz.",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: size.width * 0.015,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
              child: Row(
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
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ExamsScreen()));
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
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Attendance()));
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
              ),
            ],
          )),
        ],
      ),
    );
  }
}
