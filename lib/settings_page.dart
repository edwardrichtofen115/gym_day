import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_day/RoundedButton.dart';
import 'package:gym_day/constants.dart';
import 'package:gym_day/welcome_screen.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: FaIcon(FontAwesomeIcons.userAlt),
              ),
              SizedBox(
                width: 25.0,
              ),
              Container(
                width: 300.0,
                child: TextField(
                  textAlign: TextAlign.center,
                  enabled: false,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: _auth.currentUser.email),
                ),
              ),
            ],
          ),
          SizedBox(height: 50.0),
          RoundedButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacementNamed(context, WelcomeScreen.id);
            },
            title: 'Log out',
            colour: Colors.black,
          )
        ],
      ),
    );
  }
}
