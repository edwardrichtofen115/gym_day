import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_day/login_screen.dart';
import 'package:gym_day/settings_page.dart';
import 'package:gym_day/welcome_screen.dart';
import 'package:gym_day/workouts_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'checkin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedinScreen extends StatefulWidget {
  static String id = 'logged_in_screen';

  @override
  _LoggedinScreenState createState() => _LoggedinScreenState();
}

class _LoggedinScreenState extends State<LoggedinScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.orange,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                          child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: CheckInPage(),
                      )));
            }),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(

                    children: [

                      FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              // final progress = ProgressHUD.of(context);
                              return AlertDialog(
                                title: new Text('Alert'),
                                content: new Text(
                                    'Are you sure you want to logout?'),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new TextButton(
                                    child: new Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  new TextButton(
                                    child: new Text("Log out"),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs?.clear();

                                      await _auth.signOut();



                                      Navigator.pushReplacementNamed(
                                          context, LoginScreen.id);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          child: Icon(
                            Icons.logout,
                            size: 30.0,
                            color: Colors.orange,
                          ),
                          backgroundColor: Colors.white,
                          radius: 30.0,
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logo3.png',
                        height: 50.0,
                        width: 50.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 20.0,),
                      Text(
                        'Gym Day',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Dancing Script',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: WorkoutsPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Scaffold(
// appBar: AppBar(
// backgroundColor: Colors.orangeAccent,
// toolbarHeight: 60.0,
// automaticallyImplyLeading: false,
// bottom: TabBar(
// tabs: [
// Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 4.0, vertical: 10.0),
// child: Row(
// children: [
// FaIcon(FontAwesomeIcons.fireAlt),
// SizedBox(
// width: 10.0,
// ),
// Text('Workouts'),
// ],
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 4.0, vertical: 10.0),
// child: Row(
// children: [
// FaIcon(FontAwesomeIcons.calendarCheck),
// SizedBox(
// width: 10.0,
// ),
// Text('Check In'),
// ],
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 4.0, vertical: 10.0),
// child: Row(
// children: [
// FaIcon(FontAwesomeIcons.glassWhiskey),
// SizedBox(
// width: 10.0,
// ),
// Text('Settings'),
// ],
// ),
// ),
// ],
// ),
// ),
// body: TabBarView(
// children: [
// WorkoutsPage(),
// CheckInPage(),
// SettingsPage(),
// ],
// )),
