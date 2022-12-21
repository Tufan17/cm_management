import 'dart:convert';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../const/colors.dart';

class TimerView extends StatefulWidget {
  String courseTitle;
  int courseId;
  var userId;

  TimerView(this.courseTitle, this.courseId, this.userId);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  var channel = WebSocketChannel.connect(
    Uri.parse('ws://10.14.1.81:8080'),
  );
  int page = 0;
  var snap;
  Random random = Random();
  String totalKey = "";
  int randomNumber;

  @override
  void initState() {
    randomNumber = random.nextInt(9999) + 1000;
    totalKey = "${randomNumber.toString()}${widget.courseId.toString()}";
    Map<String, dynamic> map = {
      "type": "init",
      "user": {
        "id": widget.userId,
      },
    };
    channel.sink.add(jsonEncode(map));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: mainColor, //change your color here
        ),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, async) {
          if (async.connectionState == ConnectionState.waiting) {
            page = 0;
          } else {
            if (async.data != null) {
              snap = json.decode(async.data);
              if (snap["type"] == "students") {
                print("students");
                page = 1;
              } else if (snap["type"] == "running") {
                page = 2;
              } else if (snap["type"] == "finishedStudent") {
                page = 3;
              } else {
                print("examResult");

                page = 4;
              }
            }
          }

          switch (page) {
            case 1:
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 30),
                    child: Container(
                      width: size.width * 0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.width * 0.02,
                          ),
                          Text(
                            widget.courseTitle,
                            style: TextStyle(
                                color: mainColor,
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: size.width * 0.02,
                          ),
                          Text(
                            "Sağ taraftaki QR kodu okutarak veya gösterilen kodu girerek sınava başlayabilirsiniz\nKurallar\n1- Sınav sırasında sınavdan çıkmanız durumunda sınava girmemiş sayılacaksınız.\n2- Sınavınız devam ederken diğer öğrencilerin sınavına müdahale etmeniz veya iletişime geçmeniz sınavınızın iptal edilmesine neden olacaktır.\n3- Sınavınızı tamamladıktan sonra diğer öğrencilere müdahale etmeniz sınavınızın iptal edilmesine neden olacaktır. Sınavı tamamladıktan sonra öğretmeninizin sınavı bitirmesini bekleyiniz.",
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: size.width * 0.012,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: size.width * 0.045,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  /*Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: QuestionView(widget.courseId),
                                    ),
                                  );*/
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
                                      "Sınavı Çöz",
                                      style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width * 0.01),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  examStart();

                                  setState(() {});
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
                                      "Sınavı Başlat",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width * 0.01),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30,left:20,right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.width * 0.02,
                          ),
                          Text(
                            "Bekleyenler",
                            style: TextStyle(
                                color: mainColor,
                                fontSize: size.width * 0.025,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: snap["students"].length == null
                                  ? 0
                                  : snap["students"].length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.person),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          Text(snap["students"][index]["name"]),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: size.width * 0.12, top: 30.0),
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
                          "okutunuz ve sınavın başlamasını bekleyiniz",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: size.width * 0.01,
                              fontWeight: FontWeight.bold),
                        ),
                        QrImage(
                          data: widget.courseId.toString(),
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
                          randomNumber.toString() + widget.courseId.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              break;
            case 2:
              print(snap["students"]);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "Bitirenler",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.length,
                            itemBuilder: (context, index) {
                              return snap["type"] == null
                                  ? Container(
                                      width: size.width * 0.2,
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.courseTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02),
                        ),
                        Text(
                          "Kalan Süre",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02,
                              color: mainColor),
                        ),
                        Center(
                          child: SlideCountdownSeparated(
                            duration: Duration(minutes: 10),
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            separatorStyle: TextStyle(
                                color: mainColor, fontSize: size.width * 0.02),
                            textStyle: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            onDone: () {},
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            examFinish();
                            /* Navigator.pop(context);*/
                          },
                          child: Container(
                            height: size.width * 0.034,
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                "Sınavı Bitir ve Liderlik Tablosunu Göster",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.01),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "Sınavdakiler",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.length - 1,
                            itemBuilder: (context, index) {
                              return snap["type"] == null
                                  ? Container(
                                      width: size.width * 0.2,
                                    )
                                  : Card(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.01),
                                        child: Row(
                                          children: [
                                            Icon(Icons.person),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            Text(snap == null
                                                ? ""
                                                : snap["students"][index]["name"]
                                                    ),
                                            SizedBox(
                                              width: size.width * 0.1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
              break;
            case 3:
              print(snap["students"].toString()+" 00000");

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "Bitirenler",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap["result"].length,
                            itemBuilder: (context, index) {
                              return snap["type"] == null
                                  ? Container(
                                      width: size.width * 0.2,
                                    )
                                  : Card(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.01),
                                        child: Row(
                                          children: [
                                            Icon(Icons.person),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            Text(snap == null
                                                ? ""
                                                : snap["result"][index]
                                                    ["name"]),
                                            SizedBox(
                                              width: size.width * 0.1,
                                            ),
                                            Text(
                                              snap == null
                                                  ? "0 puan"
                                                  : snap["result"][index]
                                                              ["point"]
                                                          .toString() +
                                                      " puan",
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.courseTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02),
                        ),
                        Text(
                          "Kalan Süre",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02,
                              color: mainColor),
                        ),
                        Center(
                          child: SlideCountdownSeparated(
                            duration: Duration(minutes: 10),
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            separatorStyle: TextStyle(
                                color: mainColor, fontSize: size.width * 0.02),
                            textStyle: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            onDone: () {
                              examFinish();
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            examFinish();
                            /* Navigator.pop(context);*/
                          },
                          child: Container(
                            height: size.width * 0.034,
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                "Sınavı Bitir ve Liderlik Tablosunu Göster",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.01),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "Sınavdakiler",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap["students"].length,
                            itemBuilder: (context, index) {
                              return snap["type"] == null
                                  ? Container(
                                      width: size.width * 0.2,
                                    )
                                  : Card(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.01),
                                        child: Row(
                                          children: [
                                            Icon(Icons.person),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            Text(snap == null
                                                ? ""
                                                : snap["students"][index]
                                                    ["name"]),
                                            SizedBox(
                                              width: size.width * 0.1,
                                            ),
                                            Text(
                                              snap == null
                                                  ? "-"
                                                  : snap["students"][index]
                                                              ["name"]
                                                          .toString(),
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
              break;
            case 4:
              Map snap = jsonDecode(async.data);
              List mapEntries = snap["result"].toList();
              mapEntries.sort((a, b) => a["point"].compareTo(b["point"]));

              List reversedList = List.from(mapEntries.reversed);
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.2, right: size.width * 0.2),
                  child: Column(
                    children: [
                      Text(
                        "Liderlik Tablosu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.02,
                            color: mainColor),
                      ),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: reversedList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      index < 3
                                          ? Icon(
                                              Icons.stars_rounded,
                                              color: index == 0
                                                  ? Colors.amber
                                                  : index == 1
                                                      ? Colors.grey
                                                      : Colors.brown,
                                              size: size.width * 0.03,
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.width * 0.01),
                                              child: Text(
                                                index.toString(),
                                                style: TextStyle(
                                                    fontSize: size.width * 0.02,
                                                    color: mainColor),
                                              ),
                                            ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      Expanded(
                                        child: Text(
                                          reversedList[index]["name"]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: size.width * 0.018),
                                        ),
                                      ),
                                      Text(
                                        reversedList[index]["point"]
                                                .toString() +
                                            " puan ",
                                        style: TextStyle(
                                            fontSize: size.width * 0.018),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
              break;
            default:
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 30),
                    child: Container(
                      width: size.width * 0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.width * 0.02,
                          ),
                          Text(
                            widget.courseTitle,
                            style: TextStyle(
                                color: mainColor,
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: size.width * 0.02,
                          ),
                          Text(
                            "Sağ taraftaki QR kodu okutarak veya gösterilen kodu girerek sınava başlayabilirsiniz\nKurallar\n1- Sınav sırasında sınavdan çıkmanız durumunda sınava girmemiş sayılacaksınız.\n2- Sınavınız devam ederken diğer öğrencilerin sınavına müdahale etmeniz veya iletişime geçmeniz sınavınızın iptal edilmesine neden olacaktır.\n3- Sınavınızı tamamladıktan sonra diğer öğrencilere müdahale etmeniz sınavınızın iptal edilmesine neden olacaktır. Sınavı tamamladıktan sonra öğretmeninizin sınavı bitirmesini bekleyiniz.",
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: size.width * 0.012,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: size.width * 0.045,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  /*Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: QuestionView(widget.courseId),
                                    ),
                                  );*/
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
                                      "Sınavı Çöz",
                                      style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width * 0.01),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  examStart();

                                  setState(() {});
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
                                      "Sınavı Başlat",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width * 0.01),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*ListView.builder(
                    itemCount:
                        async.data["enteredExam"].length == null ? 0 : async.data.length,
                    itemBuilder: (context, index) {
                      return Card();
                    },
                  ),*/
                  Padding(
                    padding:
                        EdgeInsets.only(right: size.width * 0.12, top: 30.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.width * 0.02,
                        ),
                        Text(
                          "Karekodu",
                          style: TextStyle(
                              color: mainColor,
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "okutunuz ve sınavın başlamasını bekleyiniz",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: size.width * 0.01,
                              fontWeight: FontWeight.bold),
                        ),
                        QrImage(
                          data: totalKey,
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
                          randomNumber.toString() + widget.courseId.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              );
          }
          /* else if (page==1)
          {
            Map snap = jsonDecode(async.data);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 30),
                  child: Container(
                    width: size.width * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.width * 0.02,
                        ),
                        Text(
                          widget.courseTitle,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.width * 0.02,
                        ),
                        Text(
                          "Sağ taraftaki QR kodu okutarak veya gösterilen kodu girerek sınava başlayabilirsiniz\nKurallar\n1- Sınav sırasında sınavdan çıkmanız durumunda sınava girmemiş sayılacaksınız.\n2- Sınavınız devam ederken diğer öğrencilerin sınavına müdahale etmeniz veya iletişime geçmeniz sınavınızın iptal edilmesine neden olacaktır.\n3- Sınavınızı tamamladıktan sonra diğer öğrencilere müdahale etmeniz sınavınızın iptal edilmesine neden olacaktır. Sınavı tamamladıktan sonra öğretmeninizin sınavı bitirmesini bekleyiniz.",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: size.width * 0.012,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: size.width * 0.045,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                */ /*Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: QuestionView(widget.courseId),
                                    ),
                                  );*/ /*
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
                                    "Sınavı Çöz",
                                    style: TextStyle(
                                        color: mainColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.01),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                examStart();

                                setState(() {});
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
                                    "Sınavı Başlat",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.01),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snap["students"].length == null
                        ? 0
                        : snap["students"].length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                Text(snap["students"][index]["name"]),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: size.width * 0.12, top: 30.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.02,
                      ),
                      Text(
                        "QR Code",
                        style: TextStyle(
                            color: mainColor,
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.bold),
                      ),
                      QrImage(
                        data: widget.courseId.toString(),
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
                        "qlk" + widget.courseId.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            Map snap = jsonDecode(async.data);

            if (snap["type"] == "running") {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "Bitirenler",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.length,
                            itemBuilder: (context, index) {
                              return snap["type"] == null
                                  ? Container(
                                      width: size.width * 0.2,
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.courseTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02),
                        ),
                        Text(
                          "Kalan Süre",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02,
                              color: mainColor),
                        ),
                        Center(
                          child: SlideCountdownSeparated(
                            duration: Duration(minutes: 10),
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            separatorStyle: TextStyle(
                                color: mainColor, fontSize: size.width * 0.02),
                            textStyle: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            onDone: () {},
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            examFinish();
                            */ /* Navigator.pop(context);*/ /*
                          },
                          child: Container(
                            height: size.width * 0.034,
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                "Sınavı Bitir ve Liderlik Tablosunu Göster",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.01),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "Bitirenler",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.length - 1,
                            itemBuilder: (context, index) {
                              return snap["type"] == null
                                  ? Container(
                                      width: size.width * 0.2,
                                    )
                                  : Card(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.01),
                                        child: Row(
                                          children: [
                                            Icon(Icons.person),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            Text(snap == null
                                                ? ""
                                                : snap["result"][index]
                                                    ["name"]),
                                            SizedBox(
                                              width: size.width * 0.1,
                                            ),
                                            Text(
                                              snap == null
                                                  ? "0 puan"
                                                  : snap["result"][index]
                                                      ["point"],
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snap["type"] == "snapStudent") {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "Bitirenler",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap["result"].length,
                            itemBuilder: (context, index) {
                              return snap["type"] == null
                                  ? Container(
                                      width: size.width * 0.2,
                                    )
                                  : Card(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.01),
                                        child: Row(
                                          children: [
                                            Icon(Icons.person),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            Text(snap == null
                                                ? ""
                                                : snap["result"][index]
                                                    ["name"]),
                                            SizedBox(
                                              width: size.width * 0.1,
                                            ),
                                            Text(
                                              snap == null
                                                  ? "0 puan"
                                                  : snap["result"][index]
                                                              ["point"]
                                                          .toString() +
                                                      " puan",
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.courseTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02),
                        ),
                        Text(
                          "Kalan Süre",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02,
                              color: mainColor),
                        ),
                        Center(
                          child: SlideCountdownSeparated(
                            duration: Duration(minutes: 10),
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            separatorStyle: TextStyle(
                                color: mainColor, fontSize: size.width * 0.02),
                            textStyle: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            onDone: () {},
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            examFinish();
                            */ /* Navigator.pop(context);*/ /*
                          },
                          child: Container(
                            height: size.width * 0.034,
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                "Sınavı Bitir ve Liderlik Tablosunu Göster",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.01),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "Bitirenler",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap["result"].length,
                            itemBuilder: (context, index) {
                              return snap["type"] == null
                                  ? Container(
                                      width: size.width * 0.2,
                                    )
                                  : Card(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.01),
                                        child: Row(
                                          children: [
                                            Icon(Icons.person),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            Text(snap == null
                                                ? ""
                                                : snap["result"][index]
                                                    ["name"]),
                                            SizedBox(
                                              width: size.width * 0.1,
                                            ),
                                            Text(
                                              snap == null
                                                  ? "0 puan"
                                                  : snap["result"][index]
                                                              ["point"]
                                                          .toString() +
                                                      " puan",
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              Map snap = jsonDecode(async.data);
              List mapEntries = snap["result"].toList();
              mapEntries.sort((a, b) => a["point"].compareTo(b["point"]));

              List reversedList = List.from(mapEntries.reversed);

              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.2, right: size.width * 0.2),
                  child: Column(
                    children: [
                      Text(
                        "Liderlik Tablosu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.02,
                            color: mainColor),
                      ),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: reversedList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      index < 2
                                          ? Icon(
                                              Icons.stars_rounded,
                                              color: index == 0
                                                  ? Colors.amber
                                                  : index == 1
                                                      ? Colors.grey
                                                      : Colors.brown,
                                              size: size.width * 0.03,
                                            )
                                          : Text(index.toString()),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      Expanded(
                                        child: Text(
                                          reversedList[index]["name"]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: size.width * 0.018),
                                        ),
                                      ),
                                      Text(
                                        reversedList[index]["point"]
                                                .toString() +
                                            " puan ",
                                        style: TextStyle(
                                            fontSize: size.width * 0.018),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
            }
          }*/
        },
      ),
    );
  }

  examStart() {
    Map<String, dynamic> map = {
      "type": "examStart",
      "user": {
        "id": widget.userId,
      },
    };
    channel.sink.add(jsonEncode(map));
  }

  examFinish() {
    Map<String, dynamic> map = {
      "type": "examFinish",
    };
    channel.sink.add(jsonEncode(map));
  }
}
