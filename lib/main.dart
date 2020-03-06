import 'dart:async';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:game/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

void main() => runApp(new SplashScreen());

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => runApp(MyApp()));
    /* Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => MyApp()))); */
  }

  Future<void> q() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    curTheme = test[prefs.getInt('theme') ?? 0];
  }

  @override
  Widget build(BuildContext context) {
    q();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: curTheme,
        body: Center(
          child: ClayText(
            "Game",
            emboss: true,
            size: 50,
            color: curTheme,
          ),
        ),
      ),
    );
  }
}
