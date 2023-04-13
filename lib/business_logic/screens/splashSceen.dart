import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:buniess_case/business_logic/screens/onboarding/onboarding.dart';
import 'package:page_transition/page_transition.dart';



class SplashScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Lottie.asset('assets/images/welkom.json'),
        splashIconSize: 700,
        duration: 5000,
        backgroundColor: Colors.white,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
        nextScreen:Onboarding(screenHeight: MediaQuery.of(context).size.height));
  }
}