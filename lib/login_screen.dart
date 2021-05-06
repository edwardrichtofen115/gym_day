import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:gym_day/registration_screen.dart';
import 'package:gym_day/widgets/header_container.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'constants.dart';
import 'logged_in_screen.dart';

import 'package:flutter/gestures.dart';


final _auth = FirebaseAuth.instance;
class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: 30),
            height: 680.0,
            child: Column(
              children: [
                HeaderContainer('Login'),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: TextField(
                            textAlign: TextAlign.center,
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.vpn_key),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ElevatedButton(
                              child: Text('Log In'),
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  setState(() {
                                    showSpinner = true;
                                  });

                                  final loggedInUser =
                                      await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  if (loggedInUser != null) {
                                    showSpinner = false;
                                    Navigator.pushNamed(
                                        context, LoggedinScreen.id);
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } catch (e) {
                                  String _errorDescription = e.toString();
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  _showDialog(_errorDescription);
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Don't have an account ? ",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: "Register",
                                style: TextStyle(color: Colors.orange),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {
                                        print('Register'),
                                        Navigator.pushNamed(
                                            context, RegistrationScreen.id)
                                      }),
                          ]),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String errorMsg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(errorMsg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
// Padding(
// padding: EdgeInsets.symmetric(horizontal: 24.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Row(
// children: [
// FaIcon(
// FontAwesomeIcons.dumbbell,
// size: 40.0,
// ),
// SizedBox(
// height: 20.0,
// width: 30.0,
// ),
// Text(
// 'Login here',
// style: TextStyle(
// fontSize: 25.0,
// fontWeight: FontWeight.w900,
// ),
// ),
// ],
// ),
// SizedBox(
// height: 48.0,
// ),
// TextField(
// textAlign: TextAlign.center,
// keyboardType: TextInputType.emailAddress,
// onChanged: (value) {
// email = value;
// },
// decoration: kTextFieldDecoration.copyWith(
// hintText: 'Enter your email',
// ),
// ),
// SizedBox(height: 8.0),
// TextField(
// obscureText: true,
// textAlign: TextAlign.center,
// keyboardType: TextInputType.emailAddress,
// onChanged: (value) {
// password = value;
// },
// decoration: kTextFieldDecoration.copyWith(
// hintText: 'Password',
// ),
// ),
// SizedBox(
// height: 24.0,
// ),
// RoundedButton(
// onPressed: () async {
// setState(() {
// showSpinner = true;
// });
// try {
// final loggedInUser = await _auth.signInWithEmailAndPassword(
// email: email,
// password: password,
// );
//
// if (loggedInUser != null) {
// showSpinner = false;
// Navigator.pushNamed(context, LoggedinScreen.id);
// }
// setState(() {
// showSpinner = false;
// });
// } catch (e) {
// String _errorDescription = e.toString();
// setState(() {
// showSpinner = false;
// });
// _showDialog(_errorDescription);
// print(e);
// }
// },
// title: 'Login',
// colour: Colors.black,
// )
// ],
// ),
// )
