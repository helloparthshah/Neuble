import 'dart:async';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neuble/onboarding.dart';
import 'package:neuble/themes.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neuble',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  int first;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          if (_animationController.value == 1) {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 800),
                    child: first == 0 ? Intro() : HomePage()));
          }
        });
      });

    Future.delayed(Duration(seconds: 1), () {
      _animationController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> q() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    curTheme = test[prefs.getInt('theme') ?? 0];
    first = prefs.getInt('first') ?? 0;
    prefs.setInt('load', 0);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    q();

    return Scaffold(
      backgroundColor: curTheme,
      body: Center(
        child: ClayContainer(
          color: curTheme,
          height: 200,
          width: 200,
          borderRadius: 100,
          depth: (_animationController.value * 50).toInt(),
          child: Center(
            child: ClayText(
              "Neuble",
              emboss: true,
              depth: (_animationController.value * 50).toInt(),
              size: 50,
              color: curTheme,
            ),
          ),
        ),
      ),
    );
  }
}
