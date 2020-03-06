import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/services.dart';
import 'package:game/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

Timer _timer;

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  GamePageState createState() => new GamePageState();
}

class GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyWidgetState();
  }
}

class MyWidgetState extends State<MyWidget> {
  double posx = 300.0;
  double posy = 300.0;
  double x = 100, y = 100;
  double x1 = 200, y1 = 200;
  double x2 = 200, y2 = 200;
  double radius = 50;
  double pr = 10;
  int score = 0;
  int _highscore = 0;
  bool gameover = false;
  int coins = 0;
  Color themeColor;

  Random random = new Random();

  int _rup = 0, _tup = 0;
  int time = 2 * 100;

  int _start = 0;

  @override
  initState() {
    getHighScore();
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = const Duration(milliseconds: 10);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
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
    setState(() {
      _highscore = prefs.getInt('highScore') ?? 0;
      _rup = prefs.getInt('rup') ?? 0;
      _tup = prefs.getInt('tup') ?? 0;
      print(_tup);
      time = time * (_tup + 1);
      _start = time;
      coins = prefs.getInt('coins') ?? score;
      themeColor= test[prefs.getInt('theme') ?? 0];
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
                          child: ClayText(msg,
                              emboss: true, size: 30,color: themeColor,)),
                      SizedBox(
                        height: 5.0,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Center(
                          child: ClayText("Score: " + score.toString(),
                              emboss: true, size: 25,color: themeColor,)),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                          child: ClayText("HighScore: " + _highscore.toString(),
                              emboss: true, size: 25,color: themeColor,)),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                          child: ClayText("Coins: " + coins.toString(),
                              emboss: true, size: 25,color: themeColor,)),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                              child: ClayContainer(
                                color: themeColor,
                                width: 110,
                                height: 45,
                                customBorderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                                child: Center(
                                    child: ClayText("Restart",
                                        emboss: true, size: 25,color: themeColor,)),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                _timer.cancel();
                                setState(() {
                                  _start = time;
                                  posx = 300.0;
                                  posy = 300.0;
                                  x = 100;
                                  y = 100;
                                  x1 = 200;
                                  y1 = 200;
                                  x2 = 200;
                                  y2 = 200;
                                  radius = 50;
                                  pr = 10;
                                  score = 0;
                                  gameover = false;
                                });
                                startTimer();
                              },
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            InkWell(
                                child: ClayContainer(
                                  color: themeColor,
                                  width: 110,
                                  height: 45,
                                  customBorderRadius:
                                      BorderRadius.all(Radius.circular(32)),
                                  child: Center(
                                      child: ClayText("Back",
                                          emboss: true, size: 25,color: themeColor,)),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyApp()));
                                }),
                          ],
                        ),
                      ),
                    ]),
              ));
        });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void onTapDown(BuildContext context, details) {
    final RenderBox box = context.findRenderObject();
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
        // _start = time;
        _start += 50;
        if (_start > time) _start = time;
        radius += (4 - _rup);
        x = random
            .nextInt(MediaQuery.of(context).size.width.toInt())
            .toDouble();
        y = random
            .nextInt(MediaQuery.of(context).size.height.toInt())
            .toDouble();
        x1 = random
            .nextInt(MediaQuery.of(context).size.width.toInt())
            .toDouble();
        y1 = random
            .nextInt(MediaQuery.of(context).size.height.toInt())
            .toDouble();
        x2 = random
            .nextInt(MediaQuery.of(context).size.width.toInt())
            .toDouble();
        y2 = random
            .nextInt(MediaQuery.of(context).size.height.toInt())
            .toDouble();
        score++;
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
    if (score > 50) {
      if ((posx - radius / 2).toInt() <= (x2 + 10).toInt() &&
          (posx + radius / 2).toInt() >= (x2).toInt() &&
          (posy - radius / 2).toInt() <= (y2 + 10).toInt() &&
          (posy + radius / 2).toInt() >= (y2).toInt()) {
        setState(() {
          gameover = true;
        });
      }
    }
    if (gameover == true) {
      _timer.cancel();
      overAlert("You did an OOPSIE!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanUpdate: (details) => onTapDown(context, details),
      child: new Stack(fit: StackFit.expand, children: <Widget>[
        new Container(color: themeColor),
        Center(
            child: ClayText(
          (_start / 100).toString(),
          emboss: true,
          size: 50,
          color: themeColor,
        )),
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
        Positioned(
          child: Opacity(
            opacity: score > 50 ? 1 : 0,
            child: Container(
              color: Colors.blueAccent,
              height: pr,
              width: pr,
            ),
          ),
          left: x2,
          top: y2,
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
        )
      ]),
    );
  }
}
