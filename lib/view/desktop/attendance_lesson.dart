import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../const/colors.dart';

class AttendanceLesson extends StatefulWidget {
  final String name;
  const AttendanceLesson({Key key, this.name}) : super(key: key);

  @override
  State<AttendanceLesson> createState() => _AttendanceLessonState();
}

class _AttendanceLessonState extends State<AttendanceLesson> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.name + " Yoklama",
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.12, top: 30.0),
            child: Column(
              children: [
                SizedBox(
                  height: size.width * 0.02,
                ),
                Text(
                  "Karekodu",
                  style: TextStyle(
                      color: mainColor,
                      fontSize: size.width * 0.025,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Okutarak derse giriş yapınız ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: size.width * 0.01,
                      fontWeight: FontWeight.bold),
                ),
                QrImage(
                  data: "SDF3423KA".toString(),
                  version: QrVersions.auto,
                  size: size.width * 0.2,
                ),
                SizedBox(
                  height: size.width * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                        ),
                        height: 1,
                        width: 70),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Ya da",
                      style: TextStyle(
                          color: mainColor,
                          fontSize: size.width * 0.025,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                        ),
                        height: 1,
                        width: 70),
                  ],
                ),
                Text(
                  widget.name + "SDF3423KA",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
