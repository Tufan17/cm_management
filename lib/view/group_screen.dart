import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'dart:developer' as developer;

import 'package:web_socket_channel/web_socket_channel.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  int questionCount = 0;
  bool search = false;
  bool questionShort = true;
  int page = 0;
  List roomList = [];
  dynamic snap;
  List rooms = [];
  dynamic userList;
  dynamic room;
  bool roomCreate = false;
  int yourChoice = 10;
  Timer timer;
  int seconds = 20;
  bool firstGroup = true;
  int point = 0;
  List leadBoard = [];
  var channel = WebSocketChannel.connect(
    Uri.parse('ws://10.14.1.81:8080'),
  );
  TextEditingController roomNameController = TextEditingController();
  TextEditingController userCountController = TextEditingController();
  TextEditingController questionCountController = TextEditingController();

  @override
  void initState() {
    Map<String, dynamic> map = {
      "type": "init",
      "user": {
        "name": "userModel.name",
        "id": "userModel.userID",
        "avatar": "userImage",
      },
    };
    channel.sink.add(jsonEncode(map));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Stack(
            children: [
              SafeArea(
                  child: IconButton(
                onPressed: () {
                  if (page == 1 || page == 0) {
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      page = 1;
                    });
                  }
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                  size: 30,
                ),
              )),
              centerContainer(size),
            ],
          ),
        ),
      ),
    );
  }

  centerContainer(Size size) {
    return StreamBuilder(
      stream: channel.stream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
        } else {
          if (snapshot.data != null) {
            snap = json.decode(snapshot.data);

            ///Gelen Veri

            developer.log(snap.toString());
            if (snap["create"] == true) {
              room = snap["room"];
              page = 4;
            }
            if (snap["type"] == "usersInRoom") {
              rooms = snap["rooms"];
            } else if (snap["type"] == "toRoom") {
              room = snap["room"];
              questionCount =
                  int.parse(snap["room"]["questionCount"].toString());

              page = 4;
            } else if (snap["type"] == "userInfo") {
              userList = snap["users"];
              page = 5;
            } else if (snap["type"] == "questionRequest") {
              if (questionShort) {
                if (questionCount > 0) {
                  /* getQuestion().then((value) {
                    channel.sink.add(jsonEncode({
                      "type": "sendingQuestion",
                      "room": room,
                      "users": userList,
                      "question": value,
                    }));
                  });*/
                } else {
                  channel.sink.add(jsonEncode({
                    "type": "finishGroupLead",
                    "room": room,
                    "users": leadBoard,
                    "user": {
                      "name": "userModel.name",
                      "avatar": "userImage",
                      "myPoint": point,
                      "id": "userModel.userID",
                    }
                  }));
                }
              }

              page = 6;
            } else if (snap["type"] == "groupQuestion") {
              if (firstGroup) {
                questionCount--;
                seconds = 20;
                firstGroup = false;
                timer = Timer.periodic(Duration(seconds: 1), (timer) {
                  setState(() {
                    seconds--;
                  });
                  if (seconds <= 0) {
                    timer.cancel();
                    channel.sink.add(jsonEncode({
                      "type": "questionResult",
                      "room": room,
                      "users": userList,
                      "user": {
                        "name": "userModel.name",
                        "avatar": "userImage",
                        "myPoint": point,
                        "id": "userModel.userID",
                      }
                    }));
                  }
                });
              }
              page = 7;
            } else if (snap["type"] == "questionLeadBoard") {
              yourChoice = 10;
              firstGroup = true;
              questionShort = true;
              leadBoard = snap["leadBoard"]["user"];
              page = 8;
            } else if (snap["type"] == "finishGame") {
              if (firstGroup && snap["winner"]["myPoint"] > 0) {
                /*   userViewModel.userCoinHistoryAdd(
                    snap["winner"]["id"], 10, 50, 0, 0, 0, 0, "60");*/

                firstGroup = false;
              }
              if (questionShort && snap["winner"]["myPoint"] == 0) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.pop(context);
                });
                questionShort = false;
              }

              page = 9;
            }
          }
        }
        return Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  channel.sink.add(jsonEncode({
                    "type": "createRoom",
                    "room": {
                      "id": "s",
                      "name": "s",
                      "question": "s",
                      "users": [
                        {"name": "s", "id": "1", "avatar": "dd"}
                      ],
                    },
                    "user": {
                      "name": "userModel.name",
                      "avatar": "userImage",
                      "myPoint": point,
                      "id": "userModel.userID",
                    }
                  }));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  channel.sink.add(jsonEncode({
                    "type": "rooms",
                    "user": {
                      "name": "userModel.name",
                      "avatar": "userImage",
                      "myPoint": point,
                      "id": 2,
                    }
                  }));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  var channel = WebSocketChannel.connect(
                    Uri.parse('ws://10.14.1.81:8080'),
                  );
                  Map<String, dynamic> map = {
                    "type": "init",
                    "user": {
                      "name": "userModel.name",
                      "id": "userModel.userID",
                      "avatar": "userImage",
                    },
                  };
                  channel.sink.add(jsonEncode(map));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  questionTitle(Size size, snap) {
    return Container(
      //  height: size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(35),
          bottomLeft: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red,
            offset: Offset(1, 1),
            blurRadius: 1,
          ),
        ],
        color: Colors.red,
      ),
      child: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              htmlToString(snap["question"].toString()),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "poppinsMedium",
                fontSize: 15,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  answerChoice(Size size, snap) {
    String keyQuestion = snap.keys.toList().first.toString();

    Map keyOptions = snap[keyQuestion]["answer_options"];

    List list = keyOptions.keys.toList();
    return SizedBox(
      height: size.height * 0.15 * list.length,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (BuildContext context, index) {
            return SizedBox(
              height: size.height * 0.14,
              child: GestureDetector(
                onTap: () {
                  if (yourChoice == 10) {
                    setState(() {
                      yourChoice = index;
                    });
                    if (keyOptions[list[index]]["marks"] == "100") {
                      point = point + 10;
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: yourChoice == index
                        ? keyOptions[list[index]]["marks"] == "100"
                            ? Colors.green
                            : Colors.red
                        : Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        offset: Offset(1, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    htmlToString(keyOptions[list[index]]["value"].toString()),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "poppinsMedium",
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  String htmlToString(String string) {
    // var document = parse(string.toString());
    //  return document.body.text;
  }
}
