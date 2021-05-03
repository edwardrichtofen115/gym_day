import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_day/settings_page.dart';
import 'package:gym_day/workouts_page.dart';
import 'checkin_page.dart';

class LoggedinScreen extends StatefulWidget {
  static String id = 'logged_in_screen';

  @override
  _LoggedinScreenState createState() => _LoggedinScreenState();
}

class _LoggedinScreenState extends State<LoggedinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orangeAccent,
              toolbarHeight: 60.0,
              automaticallyImplyLeading: false,
              bottom: TabBar(
                tabs: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 10.0),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.fireAlt),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Workouts'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 10.0),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.calendarCheck),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Check In'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 10.0),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.glassWhiskey),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Settings'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                WorkoutsPage(),
                CheckInPage(),
                SettingsPage(),
              ],
            )),
      ),
    );
  }
}
