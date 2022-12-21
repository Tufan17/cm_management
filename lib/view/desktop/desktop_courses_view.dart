import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../const/api_const.dart';
import '../../const/colors.dart';
import 'dart:developer' as d;

import '../../services/db_services.dart';
import '../../viewModel/user_view_model.dart';
import 'desktop_home_view.dart';
import 'desktop_timer_view.dart';

class DesktopCourses extends StatefulWidget {
  @override
  State<DesktopCourses> createState() => _DesktopCoursesState();
}

class _DesktopCoursesState extends State<DesktopCourses> {
  DBService dbService = DBService();
  UserViewModel userViewModel;

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: size.width * 0.13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                border: Border.all(color: mainColor),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.leftToRight,
                      child: DesktopHome(),
                    ),
                  );
                },
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Oturumu Kapat",
                        style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.012),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Icon(
                        Icons.exit_to_app,
                        color: mainColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(right: 20.0),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
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
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Başlatmak istediğiniz sınavı seçerek ilerleyin.",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: size.width * 0.015,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: coursesMap.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: (2 / 2),
              ),
              itemBuilder: (context, index) {
                return StreamBuilder(
                  stream: getAllCourses().asStream(),
                  builder: (context, async) {
                    if (async.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20, top: 40),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[350],
                          child: Container(
                            height: size.width * 0.25,
                            width: size.width * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20, top: 40),
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: TimerView(
                                        async.data[index]["name"],
                                        async.data[index]["id"],
                                        userViewModel.userModel.id),
                                  ),
                                );
                              },
                              child: Container(
                                height: size.width * 0.25,
                                width: size.width * 0.25,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.hardLight,
                                    ),
                                    child: Image.asset(
                                      async.data[index]["name"]
                                              .toString()
                                              .contains("Öğrenme")
                                          ? "assets/courses/tur.jpg"
                                          : async.data[index]["name"]
                                                  .toString()
                                                  .contains("Ölçme")
                                              ? "assets/courses/mat.jpg"
                                              : async.data[index]["name"]
                                                      .toString()
                                                      .contains("Özel Eğitim")
                                                  ? "assets/courses/fizik.jpg"
                                                  : async.data[index]["name"]
                                                          .toString()
                                                          .contains(
                                                              "Çevre Eğitimi")
                                                      ? "assets/courses/sci.jpg"
                                                      : async.data[index]["name"]
                                                              .toString()
                                                              .contains(
                                                                  "Sosyal Etkileşim")
                                                          ? "assets/courses/bio.jpg"
                                                          : async.data[index]
                                                                      ["name"]
                                                                  .toString()
                                                                  .contains(
                                                                      "Dijital")
                                                              ? "assets/courses/history.png"
                                                              : async.data[index]["name"]
                                                                      .toString()
                                                                      .contains(
                                                                          "Güvenli Okul")
                                                                  ? "assets/courses/edebiyat.jpg"
                                                                  : async.data[index]
                                                                              ["name"]
                                                                          .toString()
                                                                          .contains("Liderlik")
                                                                      ? "assets/courses/robot.jpg"
                                                                      : async.data[index]["name"].toString().contains("Kapsayıcılık")
                                                                          ? "assets/courses/finance.jpg"
                                                                          : async.data[index]["name"].toString().contains("Duygusal")
                                                                              ? "assets/courses/data.jpg"
                                                                              : "assets/courses/social.jpg",
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: Container(
                                width: size.width * 0.13,
                                child: Text(
                                  async.data[index]['name'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                child: Text(
                                  "10 dk",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: 10,
                              child: Container(
                                child: Text(
                                  "10 Soru",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future getAllCourses() async {
    var courses = await dbService.getCourseSubject(14);
    return courses;
  }
}
