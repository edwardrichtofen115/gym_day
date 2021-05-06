import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_day/logged_in_screen.dart';
import 'package:gym_day/login_screen.dart';
import 'package:gym_day/widgets/header_container.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
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
            height: 680.0,
            padding: EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                HeaderContainer('Register'),
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
                              child: Text('Register'),
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  setState(() {
                                    showSpinner = true;
                                  });

                                  final newUser =
                                      await _auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  if (newUser != null) {
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
                                text: "Already have an account ?  ",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: "Log in here",
                                style: TextStyle(color: Colors.orange),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {
                                        print('Log In'),
                                        Navigator.pushNamed(
                                            context, LoginScreen.id)
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
