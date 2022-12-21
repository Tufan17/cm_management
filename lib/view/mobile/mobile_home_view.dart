import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import '../../const/colors.dart';
import '../../services/db_services.dart';
import 'auth/mobile_login_view.dart';
import 'auth/mobile_register_view.dart';

class MobileHome extends StatefulWidget {
  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: Row(
            children: [
              Text(
                "Classroom",
                style: TextStyle(
                    color: mainColor,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Management",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: Container(
            width: size.width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/C__1_-removebg-preview.png",
                      ),
                      SizedBox(
                        height: size.width * 0.03,
                      ),
                      Text(
                        "Hoşgeldiniz",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: size.width * 0.065,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: size.width * 0.035,
                      ),
                      Text(
                        "Onlarca konu arasından kendine uygun olanını seç ve testlere hemen başla.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: size.width * 0.032,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.2,
                      ),
                      Container(
                        width: size.width * 0.65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: mainColor,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: MobileLogin(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Giriş Yap",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.045),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.04,
                      ),
                      Container(
                        width: size.width * 0.65,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.transparent,
                            border: Border.all(color: mainColor)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: MobileRegister(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Kayıt Ol",
                                style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.045),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Memiş Ali Tufan",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: size.width * 0.032,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getCourses() async {
    var courses = await dbService.allCourses();
    return courses;
  }
}
