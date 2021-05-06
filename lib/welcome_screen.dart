import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_day/RoundedButton.dart';
import 'package:gym_day/login_screen.dart';
import 'package:gym_day/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 3000), () {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
      Navigator.pushNamed(context, LoginScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo3.png",
              color: Colors.white,
            ),
            Text(
              'Gym Day',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                  fontFamily: 'Dancing Script'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Keep Gyming, Keep Tracking',
              style: TextStyle(
                  color: Colors.white38,
                  fontSize: 30.0,
                  fontFamily: 'Dancing Script'),
            )
          ],
        ),
      ),
    );
  }
}
