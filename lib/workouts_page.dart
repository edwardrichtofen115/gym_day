import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class WorkoutsPage extends StatefulWidget {
  @override
  _WorkoutsPageState createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    Future<List<CustomWorkoutWidget>> workouts = getWorkouts();

    return Scaffold(
      body: FutureBuilder(
        future: workouts,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            // ignore: missing_return
            return ListView(children: [
              Column(
                children: snapshot.data,
              ),
            ]);
            // ignore: missing_return
          } else if (snapshot.data == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.cloudDownloadAlt,
                  size: 70.0,
                ),
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: Text(
                    'Data being fetched. Please wait',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.data.length == 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.sadCry,
                  size: 70.0,
                ),
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: Text(
                    'No workouts exist yet.\n\nCheck in to see your workouts',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            );
          } else
            return Text('Error');
        },
      ),
    );
  }
}

class CustomWorkoutWidget extends StatelessWidget {
  CustomWorkoutWidget(
      {this.workoutName, this.workoutLocation, this.workoutDateTime});

  final String workoutName;
  final String workoutLocation;
  final Timestamp workoutDateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.fire),
        title: Text(workoutName),
        subtitle: Text(
            '${workoutLocation}, on ${workoutDateTime.toDate().day}/${workoutDateTime.toDate().month}/${workoutDateTime.toDate().year} '),
      ),
    );
  }
}

Future<List<CustomWorkoutWidget>> getWorkouts() async {
  List<CustomWorkoutWidget> workouts = [];
  await _firestore
      .collection('workouts')
      .orderBy('dateTime', descending: true)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      if (element.data()['user'] == _auth.currentUser.email) {
        final temp = CustomWorkoutWidget(
            workoutName: element.data()['workout'],
            workoutLocation: element.data()['location'],
            workoutDateTime: element.data()['dateTime']);

        workouts.add(temp);
      }
    });
  });

  // if(workouts.isEmpty)
  //   return [Text('No data exists for you. Please check in to see your data')];
  // else

  return workouts;
}
