import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import '../../const/colors.dart';
import '../../services/db_services.dart';
import 'auth/desktop_login_view.dart';
import 'auth/desktop_register_view.dart';

class DesktopHome extends StatefulWidget {
  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 20,
            child: Image.asset("assets/C__1_-removebg-preview.png"),
          ),
          Positioned(
              right: 20,
              top: 20,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: DesktopRegister(),
                        ),
                      );
                    },
                    child: Container(
                      height: size.width * 0.026,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        border: Border.all(color: mainColor),
                      ),
                      child: Center(
                        child: Text(
                          "Kayıt Ol",
                          style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.012),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: DesktopLogin(),
                        ),
                      );
                    },
                    child: Container(
                      height: size.width * 0.026,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: mainColor,
                      ),
                      child: Center(
                        child: Text(
                          "Giriş Yap",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.012),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Positioned(
            right: 250,
            bottom: 30,
            child: SvgPicture.asset(
              "assets/background.svg",
              height: size.width * 0.3,
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            right: 30,
            bottom: 30,
            child: SvgPicture.asset(
              "assets/backgroundStack.svg",
              height: size.width * 0.32,
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            top: 320,
            left: 30,
            child: Container(
              width: size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hoşgeldiniz",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.width * 0.02,
                  ),
                  Text(
                    "Onlarca ders, yüzlerce soru ile sınıf arkadaşlarınla eğlenerek seviyeni belirlemeye hazır mısın? Classroom Management senin için rekabetçi bir ortam oluşturarak eğlenerek öğrenmeni sağlar. Hadi! Hemen başlayalım.",
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: size.width * 0.012,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: size.width * 0.08,
                  ),
                  Positioned(
                    right: 30,
                    bottom: 0,
                    child: SvgPicture.asset(
                      "assets/teacher.svg",
                      height: size.width * 0.32,
                      width: size.width * 0.3,
                    ),
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: WebUrl("https://www.qulak.com/iletisim/"),
                            ),
                          );
                        },
                        child: Container(
                          height: size.width * 0.03,
                          width: size.width * 0.13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: Colors.transparent,
                              border: Border.all(color: mainColor)),
                          child: Center(
                            child: Text(
                              "İletişim",
                              style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.01),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: WebUrl("https://www.qulak.com/urunlerimiz/"),
                            ),
                          );
                        },
                        child: Container(
                          height: size.width * 0.03,
                          width: size.width * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            color: mainColor,
                          ),
                          child: Center(
                            child: Text(
                              "Ürünlerimiz",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.01),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getCourses() async {
    var courses = await dbService.allCourses();
    return courses;
  }
}
