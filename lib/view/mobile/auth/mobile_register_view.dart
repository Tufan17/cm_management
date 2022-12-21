import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as d;

import '../../../const/colors.dart';
import '../../../services/auth_service.dart';
import 'mobile_login_view.dart';

class MobileRegister extends StatefulWidget {
  @override
  State<MobileRegister> createState() => _MobileRegisterState();
}

class _MobileRegisterState extends State<MobileRegister> {
  AuthService authService = AuthService();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: mainColor,
            )),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hemen Kayıt ol",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: size.width * 0.065,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Yarışma heyecanına hemen başla",
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
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
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  height: size.height * 0.065,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      prefixIcon: Icon(
                        Icons.lock,
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
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  height: size.height * 0.065,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: passwordAgainController,
                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      labelText: 'Şifre Tekrar',
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
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  height: size.height * 0.065,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: nameController,
                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      labelText: 'Ad',
                      prefixIcon: Icon(
                        Icons.person,
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
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  height: size.height * 0.065,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: surnameController,
                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      labelText: 'Soyad',
                      prefixIcon: Icon(
                        Icons.person_outline_sharp,
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
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  height: 40.0,
                  width: size.width,
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      if (isClicked == false) {
                        register(
                                mailController.text,
                                passwordController.text,
                                passwordAgainController.text,
                                nameController.text,
                                surnameController.text)
                            .then((value) {
                          if (value == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MobileLogin()));
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
                                "Devam",
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
              ),
              SizedBox(
                height: size.width * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hesabın Var Mı?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MobileLogin()));
                      },
                      child: Text("Hemen Giriş Yap",
                          style: TextStyle(
                              color: mainColor, fontWeight: FontWeight.bold))),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future register(String mail, String password, String passAgain, String name,
      String surname) async {
    var user =
        await authService.register(mail, password, passAgain, name, surname);
    return user;
  }
}
