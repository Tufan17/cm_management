import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../const/colors.dart';
import '../../viewModel/user_view_model.dart';

class QrView extends StatefulWidget {
  String courseTitle;
  int courseId;

  QrView(this.courseTitle, this.courseId);

  @override
  State<QrView> createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  UserViewModel userViewModel;

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          Padding(
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
    );
  }
}
