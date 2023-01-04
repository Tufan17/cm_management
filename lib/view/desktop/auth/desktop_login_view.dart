import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as d;

import '../../../const/colors.dart';
import '../../../services/auth_service.dart';
import '../../../viewModel/user_view_model.dart';
import '../desktop_courses_view.dart';
import 'desktop_register_view.dart';

class DesktopLogin extends StatefulWidget {
  @override
  State<DesktopLogin> createState() => _DesktopLoginState();
}

class _DesktopLoginState extends State<DesktopLogin> {
  AuthService authService = AuthService();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserViewModel userViewModel;
  bool isClicked = false;

  @override
  void dispose() {
    isClicked = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: SizedBox(
          height: size.width * 0.02,
          width: size.width * 0.02,
          child: IconButton(
            onPressed: () {
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
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    right: size.width * 0.35,
                    left: size.width * 0.35,
                    top: size.width * 0.04),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: size.width * 0.27,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/C__1_-removebg-preview.png"),
                          const Text(
                            "Karekodlu sınıf yönetimi uygulaması",
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.width * 0.02),
                    Container(
                      height: size.height * 0.065,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        controller: mailController,
                        cursorColor: mainColor,
                        decoration: InputDecoration(
                          labelText: 'E-Mail',
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: mainColor,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: mainColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: size.height * 0.065,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        cursorColor: mainColor,
                        decoration: InputDecoration(
                          labelText: 'Şifre',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: mainColor,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: mainColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.01),
                    SizedBox(height: 30),
                    Container(
                      height: 40.0,
                      width: size.width,
                      // ignore: deprecated_member_use
                      child: GestureDetector(
                        onTap: () {
                          if (isClicked == false) {
                            login("tufanmemisali17@gmail.com", "Tufan.017")
                                .then((value) {
                              if (value != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DesktopCourses()));
                              } else {
                                d.log(value.toString());
                              }
                            });
                          } else {}
                          isClicked = true;
                          setState(() {});
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: size.width, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: isClicked == false
                                ? Text(
                                    "Giriş Yap",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hesabın Yok Mu?",
                          style: TextStyle(fontSize: size.width * 0.013),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DesktopRegister()));
                            },
                            child: Text("Hemen Kayıt Ol",
                                style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.013))),
                      ],
                    ),
                    SizedBox(
                      height: size.width * 0.01,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future login(String mail, String password) async {
    var user = await userViewModel.login(mail, password);
    return user;
  }
}
