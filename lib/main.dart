import 'package:flutter/material.dart';
import 'package:gym_day/logged_in_screen.dart';
import 'package:gym_day/login_screen.dart';
import 'package:gym_day/registration_screen.dart';
import 'package:gym_day/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  final bool isUserLoggedin = email != null;

  Firebase.initializeApp();
  runApp(GymDayy());
}



class GymDayy extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Day',

      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        LoggedinScreen.id: (context) => LoggedinScreen(),
      },
    );
  }
}
