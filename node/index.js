const http = require("http");
const moment = require("moment");
const wsServing = require("websocket");
const terminal = require("terminal-kit").terminal;
const isTTY = process.stdout.isTTY;

const PORT = 8080;
const HOST = '0.0.0.0';


let server = http.createServer();

server.listen(PORT, HOST, function (err) {
    isTTY && terminal(moment().locale("tr").format("HH:mm:ss L"), " : ").green("Using port 8080, listenning now !\n");
});



let ws = new wsServing.server({
    httpServer: server,
    autoAcceptConnections: true
});

/**
 * @type {Map<string, {id:number, name:string, others:Object, socket:wsServing.connection,searching:boolean,matched:number,result:{correctCount:number,time:number}}>}
 */
let users = new Map();
let rooms = [];
let leadBoard = [];

/*
    Birebir yarış
    client:{
        "type":"init",
        "for": "one-to-one"
        "user":{
            "id": 35,
            "name": "Memiş ali",
            "avatar": "egddvvdvd",
            "others":{
                ....
            }
        }
    }
    client:{
        type:"search"
    }
    server:{
        "type":"matched",
        "id": "string"
        "name": "string",
        "avatar":"string",
        "others":{
            ....
        }
    }


    server:{
        "type":"getquestions"
    }
    client:{
        "type":"setquestions",
        "pack": [question, question,....]
    }

    client:{
        type: "examresult",
        correctCount: 15,
        time: 60
    }
    server:{
        type: "waitFinishPeer"
    }
    server:{
        type:"result",
        message: "lose"|"win"|"scoreless",
        reason: "time"|"peer disconnected"|"currectCount"
    }
*/

/*

*/

ws.addListener("connect", socket => {
    let userid = null;

    isTTY && terminal(moment().locale("tr").format("HH:mm:ss L"), " : ").green(socket.remoteAddress).white(" ").green("Client Connected")("\n");
    socket.addListener("message", async ({
        utf8Data
    }) => {
        let {
            type,
            ...request
        } = JSON.parse(utf8Data);

        switch (type) {

            case "rooms": {
                userid = request.user.id;
                users.set(request.user.id, {
                    id: request.user.id,
                    name: request.user.name,
                    avatar: request.user.avatar,
                    socket,
                });

                //    terminal("->").green(socket.remoteAddress).green("User Name :", "rooms")("\n");

                users.get(request.user.id).socket.send(JSON.stringify({
                    type: "usersInRoom",
                    rooms,
                }));
                break;
            }

            case "randomRoom": {
                userid = request.user.id;
                users.set(request.user.id, {
                    id: request.user.id,
                    name: request.user.name,
                    avatar: request.user.avatar,
                    socket,
                });

                //    terminal("->").green(socket.remoteAddress).green("User Name :", "rooms")("\n");
                for (var i = 0; i < rooms.length; i++) {
                    // terminal("->").green(JSON.stringify({
                    //     element
                    // }));
                    var roomsParse = JSON.parse(rooms[i]);

                    terminal("<<<<<<<>>>>>>").green("Naber").red(rooms)("\n");
                    terminal("<<<<<<<").green("Naber").blue(roomsParse)("\n");
                    terminal("<<<<<<<").green("Naber").red(roomsParse.room.userCount)("\n");
                    terminal("<<<<<<<").green("Naber").green(roomsParse.users.length)("\n");

                    // if (parseInt(roomsParse.room.userCount) < parseInt(roomsParse.users.length)) {
                    terminal("<<<<<<<------->>>>>>");

                    var list = roomsParse.users;
                    var room = {
                        id: roomsParse.room.id,
                        name: roomsParse.room.name,
                        questionCount: roomsParse.room.questionCount,
                        userCount: roomsParse.room.userCount,
                        user: (parseInt(roomsParse.room.user,10) + 1)
                    };


                    list.push({
                        id: request.user.id,
                        name: request.user.name,
                        avatar: request.user.avatar,
                    });
                    rooms[i] = (JSON.stringify({
                        room: room,
                        users: list,
                    }));
                    users.get(request.user.id).socket.send(JSON.stringify({
                        type: "toRoom",
                        room: room,
                        message: "Odaya yönlendiriliyorsunuz..."
                    }));
                    var userList = JSON.parse(rooms[i])["users"];
                    setTimeout(() => {
                        userList.forEach(element => {

                            users.get(element["id"]).socket.send(JSON.stringify({
                                type: "userInfo",
                                users: userList,
                            }));
                        });
                    }, 1000);
                    var roomInfo = JSON.parse(rooms[i]);
                    var a = roomInfo["users"][0];

                    setTimeout(() => {
                        if (roomInfo["room"]["userCount"] == roomInfo["room"]["user"]) {
                            users.get(roomInfo["users"][0]["id"]).socket.send(JSON.stringify({
                                type: "questionRequest",
                            }));
                        }
                    }, 2000);



                    // }
                };
            }

            case "init": {
                userid = request.user.id;
                users.set(request.user.id, {
                    id: request.user.id,
                    name: request.user.name,
                    avatar: request.user.avatar,
                    socket,
                });
                // terminal("->").green(socket.remoteAddress).green("User Auth Recaived")("\n");
                // terminal("->").green(socket.remoteAddress).green("User Name :", request.user.name)("\n");
                // terminal("->").green(socket.remoteAddress).green("User ID :", request.user.id)("\n");
                // terminal("->").green(socket.remoteAddress).green("Avatrar : ", request.user.avatar)("\n");

                break;
            }
            case "wantCreatingRoom": {
                userid = request.user.id;
                users.set(request.user.id, {
                    id: request.user.id,
                    name: request.user.name,
                    avatar: request.user.avatar,
                    socket,

                });
                // terminal("->").green("User Want Creating Room")("\n");
                // terminal("->").green("User Name :", request.user.name)("\n");
                // terminal("->").green("User ID :", request.user.id)("\n");
                // terminal("->").green("Kullanıcı Oda Oluşturmak istiyor")("\n");
                break;
            }
            case "createRoom": {
                userid = request.user.id;
                users.set(request.user.id, {
                    id: request.user.id,
                    name: request.user.name,
                    avatar: request.user.avatar,
                    socket,

                });
                // terminal("->").green("User Want Creating Room")("\n");
                // terminal("->->").green("Room Id :", request.id)("\n");
                // terminal("->").green("User Name :", request.user.name)("\n");
                // terminal("->").green("User ID :", request.user.id)("\n");
                // terminal("->").green("-----------------------")("\n");
                // terminal("->").green("ODA DETAYLARI")("\n");
                // terminal("->").green(request.room.name)("\n");
                // terminal("->").green(request.room.userCount)("\n");
                // terminal("->").green(request.room.questionCount)("\n");
                var room = {
                    id: request.id,
                    name: request.room.name,
                    questionCount: request.room.questionCount,
                    userCount: request.room.userCount,
                    user: request.room.user
                };

                rooms.push(JSON.stringify({
                    room: room,
                    users: [{
                        id: request.user.id,
                        name: request.user.name,
                        avatar: request.user.avatar,
                    }, ]

                }));
                if (request.room != null) {
                    users.get(request.user.id).socket.send(JSON.stringify({
                        create: true,
                        message: "Odanız Oluşturulmuştur",
                        room: room,
                    }));
                }
                break;
            }
            case "entranceToRoom": {
                userid = request.user.id;
                users.set(request.user.id, {
                    id: request.user.id,
                    name: request.user.name,
                    avatar: request.user.avatar,
                    socket,
                });
                var room = {
                    id: request.room.id,
                    name: request.room.name,
                    questionCount: request.room.questionCount,
                    userCount: request.room.userCount,
                    user: request.room.user
                };
                terminal("- > ").green(JSON.stringify({
                    request
                }));
                for (var i = 0; i < rooms.length; i++) {
                    var map = JSON.parse(rooms[i]);
                    var list = map["users"];
                    if (map["room"]["id"] == request.room.id) {

                        list.push({
                            id: request.user.id,
                            name: request.user.name,
                            avatar: request.user.avatar,
                        });
                        rooms[i] = (JSON.stringify({
                            room: room,
                            users: list,
                        }));
                        users.get(request.user.id).socket.send(JSON.stringify({
                            type: "toRoom",
                            room: room,
                            message: "Odaya yönlendiriliyorsunuz..."
                        }));
                        var userList = JSON.parse(rooms[i])["users"];
                        setTimeout(() => {
                            userList.forEach(element => {

                                users.get(element["id"]).socket.send(JSON.stringify({
                                    type: "userInfo",
                                    users: userList,
                                }));
                            });
                        }, 1000);
                        var roomInfo = JSON.parse(rooms[i]);
                        var a = roomInfo["users"][0];

                        setTimeout(() => {
                            if (roomInfo["room"]["userCount"] == roomInfo["room"]["user"]) {
                                users.get(roomInfo["users"][0]["id"]).socket.send(JSON.stringify({
                                    type: "questionRequest",
                                }));
                            }
                        }, 2000);

                    }

                };
                break;
            }
            case "sendingQuestion": {
                leadBoard.pop();
                request.users.forEach(element => {
                    users.get(element["id"]).socket.send(JSON.stringify({
                        type: "groupQuestion",
                        user: userList,
                        room: request.room,
                        question: request.question
                    }));
                });
                break;
            }
            case "questionResult": {
                var leadElement;

                if (leadBoard.length == 0) {

                    leadBoard.push({
                        id: request.room.id,
                        user: [request.user]
                    });

                } else {


                    leadBoard.forEach((element) => {

                        if (element["id"] == request.room.id) {

                            var list = [];

                            list = element["user"];
                            list.push(request.user);
                            for (var i = 0; i < leadBoard.length; i++) {
                                if (element == leadBoard[i]) {

                                    leadBoard[i] = {
                                        id: request.room.id,
                                        user: list,
                                    }
                                    leadElement = leadBoard[i];
                                }
                            }


                        };

                    });

                }

                request.users.forEach(element => {

                    users.get(element["id"]).socket.send(JSON.stringify({
                        type: "questionLeadBoard",
                        users: request.users,
                        room: request.room,
                        leadBoard: leadElement
                    }));
                });
                terminal(JSON.stringify(request.users));
                setTimeout(() => {

                    users.get(request.users[0]["id"]).socket.send(JSON.stringify({
                        type: "questionRequest",
                    }));

                }, 5000);
                break;
            }
            case "finishGroupLead": {
                var goodCompetitor = 0;
                var winner;
                request.users.forEach((element) => {
                    if (element["myPoint"] >= goodCompetitor) {
                        goodCompetitor = element["myPoint"];
                        winner = element;
                    };
                });
                request.users.forEach((element) => {
                    users.get(element["id"]).socket.send(JSON.stringify({
                        type: "finishGame",
                        winner: winner,
                    }));

                });

                rooms = [];


                leadBoard.pop();


                break;
            }
        }

    });
    socket.closed = false;

});