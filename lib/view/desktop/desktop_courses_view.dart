import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../const/api_const.dart';
import '../../const/colors.dart';
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
        title: Text(
          "Dersler",
          style: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.012),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: GridView.builder(
              itemCount: coursesMap.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: (2 / 2),
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: TimerView(
                              coursesMap[index]["name"],
                              coursesMap[index]["id"],
                              userViewModel.userModel.id),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(coursesMap[index]["logo"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.grey.shade900,
                        ),
                        child: Text(
                          coursesMap[index]["name"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
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
