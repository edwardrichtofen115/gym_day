import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_day/RoundedButton.dart';
import 'package:gym_day/logged_in_screen.dart';
import 'package:gym_day/login_screen.dart';
import 'package:gym_day/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 4000), () async {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool status = prefs.getBool('isLoggedIn') ?? false;

      // print(status);
      if (status) {
        Navigator.pushNamed(context, LoggedinScreen.id);
      } else {
        Navigator.pushNamed(context, LoginScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       colors: [Colors.orange, Colors.deepOrange],
        //       end: Alignment.bottomCenter,
        //       begin: Alignment.topCenter),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo3.png",
              color: Colors.white,
            ),
            Text(
              'Go Go Gym',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                  fontFamily: 'Dancing Script'),
            ),
            SizedBox(
              height: 20.0,
            ),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Keep Tracking, Keep Healthy',
                  textStyle: TextStyle(
                      color: Colors.white38,
                      fontSize: 30.0,
                      fontFamily: 'Dancing Script'),
                )
              ],
              pause: Duration(seconds: 5),
              totalRepeatCount: 2,
            ),
            // Text(
            //   'Keep Tracking, Keep Healthy',
            //   style: TextStyle(
            //       color: Colors.white38,
            //       fontSize: 30.0,
            //       fontFamily: 'Dancing Script'),
            // )
          ],
        ),
      ),
    );
  }
}
