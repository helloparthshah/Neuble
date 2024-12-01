import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:neuble/onboarding.dart';
import 'package:neuble/online.dart';
import 'package:neuble/themes.dart';
import 'package:neuble/upgrades.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Neuble',
      debugShowCheckedModeBanner: false,
      home: Home(key: UniqueKey()),
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  Home({required Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool flag = false;
  int _highscore = 0;
  int coins = 0;
  Color themeColor = curTheme;

  @override
  void initState() {
    super.initState();

    checkLoad();
  }

  Future<void> checkLoad() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('first', 1);
  }

  Future<void> getHighScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _highscore = prefs.getInt('highScore') ?? 0;
      coins = prefs.getInt('coins') ?? 0;
      themeColor = test[prefs.getInt('theme') ?? 0];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getHighScore();

    return Scaffold(
      backgroundColor: themeColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Align(
            alignment: Alignment.topCenter,
            child: ClayText(
              "Neuble",
              emboss: true,
              size: 70,
              color: themeColor,
              style: TextStyle(decoration: TextDecoration.none),
            ),
          ),
          SizedBox(height: 50),
          GestureDetector(
            child: Hero(
              tag: 'btn1',
              child: ClayContainer(
                color: themeColor,
                width: 150,
                height: 55,
                customBorderRadius: BorderRadius.all(Radius.circular(40)),
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: ClayText(
                      "Start!",
                      emboss: true,
                      size: 25,
                      color: themeColor,
                      style: TextStyle(decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ),
            ),
            onTap: () async {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                      child: GamePage()));
            },
          ),
          SizedBox(height: 25),
          GestureDetector(
            child: ClayContainer(
              color: themeColor,
              width: 150,
              height: 55,
              customBorderRadius: BorderRadius.all(Radius.circular(40)),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: ClayText(
                    "Online",
                    emboss: true,
                    size: 25,
                    color: themeColor,
                    style: TextStyle(decoration: TextDecoration.none),
                  ),
                ),
              ),
            ),
            onTap: () async {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                      child: OnlineGame()));
            },
          ),
          SizedBox(height: 25),
          GestureDetector(
            child: Hero(
              tag: 'btn2',
              child: ClayContainer(
                color: themeColor,
                width: 150,
                height: 55,
                customBorderRadius: BorderRadius.all(Radius.circular(40)),
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: ClayText(
                      "Upgrades",
                      emboss: true,
                      size: 25,
                      color: themeColor,
                      style: TextStyle(decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                      child: Upgrades()));
            },
          ),
          SizedBox(height: 50),
          ClayText(
            "Highscore: " + _highscore.toString(),
            emboss: true,
            size: 35,
            color: themeColor,
          ),
          SizedBox(height: 10),
          ClayText(
            "Coins: " + coins.toString(),
            emboss: true,
            size: 35,
            color: themeColor,
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: ClayContainer(
                    color: themeColor,
                    width: 110,
                    height: 40,
                    customBorderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Center(
                      child: ClayText(
                        "Reset",
                        emboss: true,
                        size: 20,
                        color: themeColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0))),
                          content: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                    child: ClayText(
                                  "Alert",
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
                                  "Are You Sure?",
                                  emboss: true,
                                  size: 25,
                                  color: themeColor,
                                )),
                                SizedBox(
                                  height: 40.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                        child: ClayContainer(
                                          color: themeColor,
                                          width: 100,
                                          height: 45,
                                          customBorderRadius: BorderRadius.all(
                                              Radius.circular(32)),
                                          child: Center(
                                              child: ClayText(
                                            "NO",
                                            emboss: true,
                                            size: 25,
                                            color: themeColor,
                                          )),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        }),
                                    GestureDetector(
                                        child: ClayContainer(
                                          color: themeColor,
                                          width: 100,
                                          height: 45,
                                          customBorderRadius: BorderRadius.all(
                                              Radius.circular(32)),
                                          child: Center(
                                              child: ClayText(
                                            "YES",
                                            emboss: true,
                                            size: 25,
                                            color: themeColor,
                                          )),
                                        ),
                                        onTap: () {
                                          reset();
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                GestureDetector(
                  child: ClayContainer(
                    color: themeColor,
                    width: 110,
                    height: 40,
                    customBorderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Center(
                      child: ClayText(
                        "Help",
                        emboss: true,
                        size: 20,
                        color: themeColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 500),
                            child: Intro()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> reset() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('highScore', 0);
    await prefs.setInt('coins', 0);

    List<String> upgList = ['0', '0', '0'].map((i) => i.toString()).toList();
    prefs.setStringList("upgList", upgList);

    List<int> cols = new List<int>.filled(test.length, 0);
    cols[0] = 1;
    List<String> colList = cols.map((i) => i.toString()).toList();
    prefs.setStringList("colorsList", colList);

    prefs.setInt('first', 0);

    await prefs.setInt('theme', 0);
  }
}
