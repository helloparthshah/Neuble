import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

List<PageViewModel> pages = [
  PageViewModel(
      title: "Play!",
      body: "Drag your finger across the screen in order to move. ",
      image: Center(
        child: Image.network("https://i.ibb.co/nksLjGV/Web-1920-1.png",
            height: 300.0),
      ),
      decoration: PageDecoration(
        pageColor: Color(0xFFCDD9E7),
      )),
  PageViewModel(
    title: "Remember!",
    body: "Red is good blue is bad. STAY AWAY FROM BLUE!!",
    image: Center(
        child: Image.network("https://i.ibb.co/QCpGYF5/Web-1920-1.png",
            height: 300.0)),
    decoration: const PageDecoration(
      pageColor: Color(0xFFE4842D),
    ),
  ),
  PageViewModel(
    title: "Remember!",
    body: "Red is good blue is bad. STAY AWAY FROM BLUE!!",
    image: Center(
        child: Image.network("https://i.ibb.co/QCpGYF5/Web-1920-1.png",
            height: 300.0)),
    decoration: const PageDecoration(
      pageColor: Color(0xFF55BAEF),
    ),
  ),
];

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neuble',
      debugShowCheckedModeBanner: false,
      home: IntroductionScreen(
        pages: pages,
        onDone: () {
          Navigator.of(context).pop();
        },
        onSkip: () {
          Navigator.of(context).pop();
        },
        showSkipButton: true,
        skip: const Text(
          'Skip',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        next: const Text(
          'Next',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        done: const Text(
          "Done",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Color(0xFF33373D),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
