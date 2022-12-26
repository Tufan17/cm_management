import 'dart:convert';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as d;
import '../../../const/api_const.dart';
import '../../../const/colors.dart';
import '../../../services/auth_service.dart';
import '../../../viewModel/user_view_model.dart';
import '../mobile_scan_view.dart';
import 'package:http/http.dart' as http;

class MobileLogin extends StatefulWidget {
  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  AuthService authService = AuthService();

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isClicked = false;

  @override
  void dispose() {
    isClicked = false;
    super.dispose();
  }

  UserViewModel userViewModel;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
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
        ],
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              right: size.width * 0.045,
              left: size.width * 0.045,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "assets/C__1_-removebg-preview.png",
                ),
                Container(
                  width: size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Giriş Yap",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: size.width * 0.065,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Yarışmaya Hemen Başla !",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: size.width * 0.032,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.width * 0.1,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Text(
                      "Şifremi Unuttum",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  height: 40.0,
                  width: size.width,
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      login("tufanmemisali17@gmail.com", "Tufan.017");
                      // if (isClicked == false) {
                      //   login("tufanmemisali@gmail.com", "Tufan.017")
                      //       .then((value) {
                      //     if (value != null) {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => Scan()));
                      //     } else {
                      //       d.log(value.toString());
                      //     }
                      //   });
                      // } else {}
                      //
                      // isClicked = true;
                      // setState(() {});
                    },
                    // elevation: 8,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(20.0),
                    // ),
                    // padding: EdgeInsets.all(0.0),
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
                SizedBox(
                  height: size.width * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login(String mail, String password) async {
    dynamic response = await http.post(
      Uri.parse('http://172.20.10.2:81/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': mail, 'password': password}),
    );

    // loginCookie = response.headers["set-cookie"].split(";")[0].toString();

    dynamic userJson = jsonDecode(response.body);
    print(userJson.toString());
  }
}
