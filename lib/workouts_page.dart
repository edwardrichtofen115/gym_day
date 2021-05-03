import 'package:cloud_firestore/cloud_firestore.dart';
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
        future: getWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ignore: missing_return
            return ListView(children: [
              Column(
                children: snapshot.data,
              ),
            ]);
          } else {
            return Text(
                'No workouts added yet. Check in your workouts to see them here.');
          }
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
  await _firestore.collection('workouts').get().then((value) {
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

  return workouts;
}
