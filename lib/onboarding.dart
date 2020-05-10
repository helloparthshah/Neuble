import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
            title: "Play!",
            body: "Drag your finger across the screen in order to move. ",
            image: Center(
              child: Image.asset('lib/assets/img1.png', height: 300.0),
            ),
            decoration: PageDecoration(
              pageColor: Colors.transparent,
            )),
        PageViewModel(
          title: "Remember!",
          body: "Red is good blue is bad. STAY AWAY FROM BLUE!!",
          image:
              Center(child: Image.asset('lib/assets/img2.png', height: 300.0)),
          decoration: const PageDecoration(
            pageColor: Colors.transparent,
          ),
        ),
        PageViewModel(
          title: "Good Luck!",
          body: "Try to score the most points without dying.\nYOU GOT THIS!",
          image: Center(
              child: Container(
            height: 300.0,
          )),
          decoration: const PageDecoration(
            pageColor: Colors.transparent,
          ),
        ),
      ],
      onDone: () {
        Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 800),
                    child:HomePage()));
        // Navigator.pop(context);
      },
      onSkip: () {
        Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 800),
                    child:HomePage()));
        // Navigator.pop(context);
      },
      globalBackgroundColor: Color(0xFFCDD9E7),
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
        "Let's Play!",
        style: TextStyle(
          fontSize: 18.0,
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
    );
  }
}
