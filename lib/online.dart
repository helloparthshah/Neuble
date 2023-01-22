import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/services.dart';
import 'package:neuble/themes.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class OnlineGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      title: 'Neuble',
      debugShowCheckedModeBanner: false,
      home: Game(),
    );
  }
}

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GameState();
  }
}

class GameState extends State<Game> {
  late Timer _timer;
  double opponentX = 300.0;
  double opponentY = 300.0;
  double posx = 300.0;
  double posy = 300.0;
  double x = 100, y = 100;
  double x1 = 200, y1 = 200;
  double radius = 50;
  double opponentRadius = 50;
  double pr = 10;
  int score = 0;
  int opponentScore = 0;
  int _highscore = 0;
  bool gameover = false;
  int coins = 0;
  late Color themeColor;

  int comboTime = 0;

  int oldtime = 200, newtime = 0, combo = 1;

  Random random = new Random();

  int _rup = 0, _tup = 0;
  int time = 12 * 100;

  int _start = 0;

  bool hasStart = false;
  var channel;
  @override
  initState() {
    getHighScore();
    // startTimer();
    // _timer.cancel();

    setState(() {
      // channel = IOWebSocketChannel.connect(Uri.parse('ws://parth-laptop:3000'));
      channel = WebSocketChannel.connect(
          Uri.parse('wss://neuble-server.onrender.com/'));
    });
    channel.sink.add("Hello");
    setState(() {
      x = random.nextInt(500).toDouble();
      y = random.nextInt(500).toDouble();
    });
    channel.stream.listen((data) {
      print(data);
      setState(() {
        if (data == 'Disconnected') {
          if (_timer != null) _timer.cancel();
          channel.sink.close();
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                  child: HomePage()));

          print('Disconnected');
          return;
        }
        if (data == 'gameover') {
          _timer.cancel();
          overAlert("You Win");
          return;
        }
        if (data != "Waiting" && !hasStart) {
          print("Started");
          startTimer();
          hasStart = true;
        }
        if (hasStart && data != "Waiting" && data != "gameover") {
          print(data);
          opponentX = double.parse(data.split(",")[0]) *
              MediaQuery.of(context).size.width;
          opponentY = double.parse(data.split(",")[1]) *
              MediaQuery.of(context).size.height;
          x1 = double.parse(data.split(",")[2]) *
              MediaQuery.of(context).size.width;
          y1 = double.parse(data.split(",")[3]) *
              MediaQuery.of(context).size.height;
          opponentRadius = double.parse(data.split(",")[4]);
          opponentScore = int.parse(data.split(",")[5]);
        }
      });
    }, onError: (error) {
      print(error);
    });
    super.initState();
  }

  void startTimer() {
    const oneSec = const Duration(milliseconds: 10);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          try {
            channel.sink.add(
                "${posx / MediaQuery.of(context).size.width},${posy / MediaQuery.of(context).size.height},${x / MediaQuery.of(context).size.width},${y / MediaQuery.of(context).size.height},${radius},${score}");
          } catch (e) {
            print(e);
          }
          if (_start < 1) {
            timer.cancel();
            channel.sink.add("gameover");
            overAlert("Too Slow!");
          } else {
            checkCollision();
            _start = _start - 1;
          }
        },
      ),
    );
  }

  Future<void> getHighScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<int> upgList = (prefs.getStringList('upgList') ?? ['0', '0', '0'])
        .map((i) => int.parse(i))
        .toList();

    setState(() {
      _highscore = prefs.getInt('highScore') ?? 0;
      _rup = 1;
      _tup = 1;
      comboTime = 1;
      comboTime *= 25;
      _start = time;
      coins = prefs.getInt('coins') ?? score;
      themeColor = test[prefs.getInt('theme') ?? 0];
      combo = 0;
    });
  }

  Future<void> check() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (score > _highscore) {
      setState(() {
        _highscore = score;
      });
      await prefs.setInt('highScore', _highscore);
    }
    await prefs.setInt('coins', coins);
  }

  void overAlert(String msg) {
    setState(() {
      coins += score;
    });
    check();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                    child: ClayText(
                  msg,
                  emboss: true,
                  size: 30,
                  color: themeColor,
                )),
                SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Center(
                    child: ClayText(
                  "Score: " + score.toString(),
                  emboss: true,
                  size: 25,
                  color: themeColor,
                )),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: ClayText(
                  "HighScore: " + _highscore.toString(),
                  emboss: true,
                  size: 25,
                  color: themeColor,
                )),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: ClayText(
                  "Coins: " + coins.toString(),
                  emboss: true,
                  size: 25,
                  color: themeColor,
                )),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        child: ClayContainer(
                          color: themeColor,
                          width: 110,
                          height: 45,
                          customBorderRadius:
                              BorderRadius.all(Radius.circular(32)),
                          child: Center(
                              child: ClayText(
                            "Search",
                            emboss: true,
                            size: 25,
                            color: themeColor,
                          )),
                        ),
                        onTap: () {
                          _timer.cancel();
                          // channel.sink.close(status.normalClosure);
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new OnlineGame()));
                        },
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      GestureDetector(
                        child: ClayContainer(
                          color: themeColor,
                          width: 110,
                          height: 45,
                          customBorderRadius:
                              BorderRadius.all(Radius.circular(32)),
                          child: Center(
                              child: ClayText(
                            "Back",
                            emboss: true,
                            size: 25,
                            color: themeColor,
                          )),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                  child: HomePage()));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    channel.sink.close();
    super.dispose();
  }

  void onTapDown(BuildContext context, details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      posx = localOffset.dx;
      posy = localOffset.dy;
    });
  }

  void checkCollision() {
    if ((posx - radius / 2).toInt() <= (x + 10).toInt() &&
        (posx + radius / 2).toInt() >= (x).toInt() &&
        (posy - radius / 2).toInt() <= (y + 10).toInt() &&
        (posy + radius / 2).toInt() >= (y).toInt()) {
      setState(() {
        newtime = _start;
        if (oldtime - newtime <= comboTime) {
          combo++;
        } else {
          combo = 1;
        }
        _start += 50;
        if (_start > time) _start = time;
        radius += (4 - _rup);
        x = pr +
            random
                .nextInt(
                    MediaQuery.of(context).size.width.toInt() - 2 * pr.toInt())
                .toDouble();
        y = pr +
            random
                .nextInt(
                    MediaQuery.of(context).size.height.toInt() - 2 * pr.toInt())
                .toDouble();
        score += combo;
        oldtime = _start;
      });
    }
    if ((posx - radius / 2).toInt() <= (x1 + 10).toInt() &&
        (posx + radius / 2).toInt() >= (x1).toInt() &&
        (posy - radius / 2).toInt() <= (y1 + 10).toInt() &&
        (posy + radius / 2).toInt() >= (y1).toInt()) {
      setState(() {
        gameover = true;
      });
    }

    if (gameover == true) {
      _timer.cancel();
      channel.sink.add("gameover");
      overAlert("You did an OOPSIE!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: hasStart
          ? new GestureDetector(
              onPanUpdate: (details) => onTapDown(context, details),
              child: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Container(color: themeColor),
                  Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        ClayText(
                          (_start / 100).toString(),
                          emboss: true,
                          size: 50,
                          color: themeColor,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ClayText(
                          combo > 1 ? 'x' + (combo).toString() : "",
                          emboss: true,
                          size: 50,
                          color: themeColor,
                        ),
                      ])),
                  Positioned(
                    child: Container(
                      color: Colors.redAccent,
                      height: pr,
                      width: pr,
                    ),
                    left: x,
                    top: y,
                  ),
                  Positioned(
                    child: Container(
                      color: Colors.blueAccent,
                      height: pr,
                      width: pr,
                    ),
                    left: x1,
                    top: y1,
                  ),
                  new Positioned(
                    child: ClayContainer(
                      color: themeColor,
                      height: radius,
                      width: radius,
                      borderRadius: 75,
                      curveType: CurveType.convex,
                      child: Center(
                        child: ClayText(
                          score.toString(),
                          emboss: true,
                          size: radius / 2,
                          color: themeColor,
                        ),
                      ),
                    ),
                    left: posx - radius / 2,
                    top: posy - radius / 2,
                  ),
                  new Positioned(
                    child: ClayContainer(
                      color: themeColor,
                      height: opponentRadius,
                      width: opponentRadius,
                      borderRadius: 75,
                      curveType: CurveType.convex,
                      child: Center(
                        child: ClayText(
                          opponentScore.toString(),
                          emboss: true,
                          size: opponentRadius / 2,
                          color: themeColor,
                        ),
                      ),
                    ),
                    left: opponentX - opponentRadius / 2,
                    top: opponentY - opponentRadius / 2,
                  )
                ],
              ),
            )
          : Container(
              color: themeColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClayText(
                      "Loading...",
                      emboss: true,
                      size: 50,
                      color: themeColor,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      child: ClayContainer(
                        color: themeColor,
                        width: 110,
                        height: 45,
                        customBorderRadius:
                            BorderRadius.all(Radius.circular(32)),
                        child: Center(
                            child: ClayText(
                          "Back",
                          emboss: true,
                          size: 25,
                          color: themeColor,
                        )),
                      ),
                      onTap: () {
                        if (_timer != null) _timer.cancel();
                        channel.sink.close();
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                                child: HomePage()));
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
