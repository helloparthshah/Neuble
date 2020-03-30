import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/services.dart';
import 'package:game/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Col extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new ColPage(),
    );
  }
}

class ColPage extends StatefulWidget {
  @override
  ColPageState createState() => new ColPageState();
}

class ColPageState extends State<ColPage> {
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
  int theme = 0;
  List<int> cols = totCols;
  Color themeColor = curTheme;
  int cost = 500;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cols[0] = 1;
      cols[1] = prefs.getInt('p') ?? 0;
      cols[2] = prefs.getInt('d') ?? 0;
      cols[3] = prefs.getInt('r') ?? 0;
      cols[4] = prefs.getInt('t') ?? 0;
      themeColor = test[prefs.getInt('theme') ?? 0];
      coins = prefs.getInt('coins') ?? 0;
    });
  }

  Future<void> check() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', coins);
    await prefs.setInt('g', cols[0]);
    await prefs.setInt('p', cols[1]);
    await prefs.setInt('d', cols[2]);
    await prefs.setInt('r', cols[3]);
    await prefs.setInt('t', cols[4]);
    await prefs.setInt('theme', theme);
    setState(() {
      themeColor = test[prefs.getInt('theme') ?? 0];
    });
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
                      InkWell(
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

  Widget colorTile(int key) {
    return Container(
        width: 200,
        child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
                child: ClayContainer(
                  emboss: cols[key] == 1 ? false : true,
                  curveType:
                      cols[key] == 1 ? CurveType.convex : CurveType.concave,
                  color: themeColor,
                  height: 200,
                  width: 200,
                  borderRadius: 25,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                        color: test[key],
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    if ((coins - cost) >= 0 && cols[key] != 1) {
                      coins -= cost;
                      cols[key]++;
                    } else if (cols[key] == 1) {
                      theme = key;
                    } else {
                      showAlert("Not Enough Coins!");
                    }
                    if (cols[key] == 1) theme = key;
                    check();
                  });
                }),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 200,
            child: Opacity(
              opacity: 0.5,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color:
                      cols[key] == 1 ? Color(0xFF29c7ac) : Colors.transparent,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: Text(
                  key==0?"Free":cost.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
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
                height: 250,
                child: ListView(
                  physics: new BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                    ),
                    colorTile(0),
                    SizedBox(
                      width: 50,
                    ),
                    colorTile(1),
                    SizedBox(
                      width: 50,
                    ),
                    colorTile(2),
                    SizedBox(
                      width: 50,
                    ),
                    colorTile(3),
                    SizedBox(
                      width: 50,
                    ),
                    colorTile(4),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                  child: ClayContainer(
                    color: themeColor,
                    width: 100,
                    height: 45,
                    customBorderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Center(
                        child: ClayText(
                      "Back",
                      emboss: true,
                      size: 20,
                      color: themeColor,
                    )),
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
