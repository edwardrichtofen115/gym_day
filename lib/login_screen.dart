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
import 'package:shared_preferences/shared_preferences.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Form(
        key: _formKey,
        child: ModalProgressHUD(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.only(left: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field cannot be empty';
                                  }
                                  return null;
                                },
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.only(left: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field cannot be empty';
                                  }
                                  return null;
                                },
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
                                    final formState = _formKey.currentState;
                                    if (formState.validate()) {
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      try {
                                        setState(() {
                                          showSpinner = true;
                                        });

                                        final loggedInUser = await _auth
                                            .signInWithEmailAndPassword(
                                          email: email,
                                          password: password,
                                        );
                                        if (loggedInUser != null) {
                                          showSpinner = false;
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setBool("isLoggedIn", true);
                                          prefs.setString('user_email', email);
                                          Navigator.pushNamed(
                                              context, LoggedinScreen.id);
                                        }
                                        setState(() {
                                          showSpinner = false;
                                        });
                                      } catch (e) {
                                        String _errorDescription;
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        print(e.code);
                                        switch (e.code) {
                                          case "ERROR_EMAIL_ALREADY_IN_USE":
                                          case "account-exists-with-different-credential":
                                          case "email-already-in-use":
                                            _errorDescription =
                                                "Email already used. Go to login page.";
                                            break;
                                          case "ERROR_WRONG_PASSWORD":
                                          case "wrong-password":
                                            _errorDescription =
                                                "Wrong email/password combination.";
                                            break;
                                          case "ERROR_USER_NOT_FOUND":
                                          case "user-not-found":
                                            _errorDescription =
                                                "No user found with this email.";
                                            break;
                                          case "ERROR_USER_DISABLED":
                                          case "user-disabled":
                                            _errorDescription =
                                                "User disabled.";
                                            break;
                                          case "ERROR_TOO_MANY_REQUESTS":
                                          case "operation-not-allowed":
                                            _errorDescription =
                                                "Too many requests to log into this account.";
                                            break;
                                          case "ERROR_OPERATION_NOT_ALLOWED":
                                          case "operation-not-allowed":
                                            _errorDescription =
                                                "Server error, please try again later.";
                                            break;
                                          case "ERROR_INVALID_EMAIL":
                                          case "invalid-email":
                                            _errorDescription =
                                                "Email address is invalid.";
                                            break;
                                          default:
                                            _errorDescription =
                                                "Login failed. Please try again.";
                                            break;
                                        }
                                        _showDialog(_errorDescription);
                                        print(_errorDescription);
                                      }
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
                                            // print('Register'),
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
