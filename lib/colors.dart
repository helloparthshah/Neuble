import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/services.dart';
import 'package:neuble/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Col extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: new ColorsPage(),
    );
  }
}

class ColorsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ColorsPageState();
  }
}

class ColorsPageState extends State<ColorsPage> {
  int coins = 0;
  int theme = 0;
  List<int> cols = new List<int>.filled(test.length, 0);
  Color themeColor = curTheme;
  int cost = 500;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int> colorsList = List<int>.filled(test.length, 0);
    if (prefs.getStringList('colorsList') != null) {
      colorsList =
          prefs.getStringList('colorsList').map((i) => int.parse(i)).toList();
    } else {
      colorsList[0] = 1;
    }
    /* List<int> colorsList = (prefs.getStringList('colorsList') ??
            List<String>.filled(test.length, '0'))
        .map((i) {
      // check if
      return int.parse(i);
    }).toList(); */

    setState(() {
      cols = colorsList;

      themeColor = test[prefs.getInt('theme') ?? 0];
      curTheme = themeColor;
      coins = prefs.getInt('coins') ?? 0;
    });
  }

  Future<void> check() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('coins', coins);

    List<String> strList = cols.map((i) => i.toString()).toList();
    prefs.setStringList("colorsList", strList);

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

  Widget colorTile(int key) {
    return Container(
        width: 200,
        child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Center(
            child: GestureDetector(
                child: ClayContainer(
                  emboss: cols[key] == 1 ? false : true,
                  curveType:
                      cols[key] == 1 ? CurveType.convex : CurveType.concave,
                  color: themeColor,
                  height: 150,
                  width: 150,
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
            width: 150,
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
                  key == 0 ? "Free" : cost.toString(),
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
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  physics: new BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: cols.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(cols.length);
                    return colorTile(index);
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  child: ClayContainer(
                    color: themeColor,
                    width: 100,
                    height: 45,
                    customBorderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Center(
                        child: Material(
                      color: Colors.transparent,
                      child: ClayText(
                        "Back",
                        emboss: true,
                        size: 20,
                        color: themeColor,
                      ),
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
