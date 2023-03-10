import 'package:cm_flutter/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../services/db_services.dart';
import '../../viewModel/user_view_model.dart';
import 'desktop_courses_view.dart';
import 'desktop_timer_view.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({Key key}) : super(key: key);

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
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
                        child: TimerView(exam[index]["name"], exam[index]["id"],
                            userViewModel.userModel.id),
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
                          Expanded(child: Image.asset("assets/exam.png")),
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

  getExams() async {
    return await DBService().getExams();
  }
}
