import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_day/login_screen.dart';
import 'package:gym_day/settings_page.dart';
import 'package:gym_day/welcome_screen.dart';
import 'package:gym_day/workouts_page.dart';
import 'checkin_page.dart';

class LoggedinScreen extends StatefulWidget {
  static String id = 'logged_in_screen';

  @override
  _LoggedinScreenState createState() => _LoggedinScreenState();
}

class _LoggedinScreenState extends State<LoggedinScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    CircleAvatar(
                      child: Icon(
                        Icons.directions_run,
                        size: 30.0,
                        color: Colors.orange,
                      ),
                      backgroundColor: Colors.white,
                      radius: 30.0,
                    ),
                    FlatButton(

                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _auth.signOut();
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.id);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.logout,
                          size: 30.0,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: 30.0,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Gym Day',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700,
                  ),
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
