import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/services.dart';
import 'package:game/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

class Upgrades extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new UpgradesPage(),
    );
  }
}

class UpgradesPage extends StatefulWidget {
  @override
  UpgradesPageState createState() => new UpgradesPageState();
}

class UpgradesPageState extends State<UpgradesPage> {
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
  int coins = 0;
  List<int> upg = [0, 0, 0];
  Color themeColor = curTheme;
  int cost = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      themeColor = test[prefs.getInt('theme') ?? 0];
    });
  }

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<int> upgList = (prefs.getStringList('upgList') ?? ['0', '0', '0'])
        .map((i) => int.parse(i))
        .toList();

    setState(() {
      upg = upgList;
      coins = prefs.getInt('coins') ?? 0;
      themeColor = test[prefs.getInt('theme') ?? 0];
    });
  }

  Future<void> check() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', coins);

    List<String> strList = upg.map((i) => i.toString()).toList();
    prefs.setStringList("upgList", strList);
  }

  void showAlert(String msg) {
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
                        "Purchase Error!",
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
                        msg,
                        emboss: true,
                        size: 25,
                        color: themeColor,
                      )),
                      SizedBox(
                        height: 40.0,
                      ),
                      GestureDetector(
                          child: ClayContainer(
                            color: themeColor,
                            width: 30,
                            height: 45,
                            customBorderRadius:
                                BorderRadius.all(Radius.circular(32)),
                            child: Center(
                                child: ClayText(
                              "OK",
                              emboss: true,
                              size: 25,
                              color: themeColor,
                            )),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                    ]),
              ));
        });
  }

  Widget updCard(int key, String name) {
    return Container(
        width: 200,
        child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Center(
            child: GestureDetector(
                child: ClayContainer(
                  color: themeColor,
                  height: 150,
                  width: 150,
                  borderRadius: 25,
                  child: Center(
                    child: ClayText(
                      name,
                      emboss: true,
                      size: 40,
                      color: themeColor,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    cost = 500 * (upg[key] + 1);
                    if ((coins - cost) >= 0 && upg[key] != 3) {
                      coins -= cost;
                      upg[key]++;
                      check();
                    } else if (upg[key] == 3) {
                      showAlert("Already at max");
                    } else {
                      showAlert("Not Enough Coins!");
                    }
                  });
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Opacity(
            opacity: 0.5,
            child: SizedBox(
              width: 150,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 150 / 3 - 3,
                    decoration: BoxDecoration(
                      color: (upg[key] > 0)
                          ? Color(0xFF29c7ac)
                          : Colors.transparent,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    ),
                    child: Text(
                      '500',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 4.5,
                  ),
                  Container(
                    height: 20,
                    width: 150 / 3 - 3,
                    decoration: BoxDecoration(
                      color:
                          upg[key] > 1 ? Color(0xFF29c7ac) : Colors.transparent,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    ),
                    child: Text(
                      "1000",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 4.5,
                  ),
                  Container(
                    height: 20,
                    width: 150 / 3 - 3,
                    decoration: BoxDecoration(
                      color:
                          upg[key] > 2 ? Color(0xFF29c7ac) : Colors.transparent,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    ),
                    child: Text(
                      "1500",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    getTheme();
    return Material(
      child: Container(
        color: themeColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClayText(
                "Coins: " + coins.toString(),
                emboss: true,
                size: 50,
                color: themeColor,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 230,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  physics: new BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    updCard(0, "Size"),
                    updCard(1, "Time"),
                    updCard(2, "Combo"),
                  ],
                ),
              ),
              GestureDetector(
                  child: Hero(
                    tag: 'btn1',
                    child: ClayContainer(
                      color: themeColor,
                      width: 100,
                      height: 45,
                      customBorderRadius: BorderRadius.all(Radius.circular(40)),
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: ClayText(
                            "Colors",
                            emboss: true,
                            size: 20,
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
                      MaterialPageRoute(builder: (context) => Col()),
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  child: Hero(
                    tag: 'btn2',
                    child: ClayContainer(
                      color: themeColor,
                      width: 100,
                      height: 45,
                      customBorderRadius: BorderRadius.all(Radius.circular(40)),
                      child: Center(
                          child: Material(
                        color: Colors.transparent,
                        child: ClayText("Back",
                            emboss: true,
                            size: 20,
                            color: themeColor,
                            style: TextStyle(decoration: TextDecoration.none)),
                      )),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
