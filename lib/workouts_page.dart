import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_day/checkin_form.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class WorkoutsPage extends StatefulWidget {
  @override
  _WorkoutsPageState createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestore.collection('workouts').orderBy('dateTime').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final workouts = snapshot.data.docs;
            for (var workout in workouts) {
              print(workout.data()['workout']);
            }
            List<CustomWorkoutWidget> finalWorkouts = getWorkouts(workouts);
            return ListView(
              children: finalWorkouts,
            );
          } else
            return Text('Error');
        },
      ),
    );
  }
}

class CustomWorkoutWidget extends StatefulWidget {
  CustomWorkoutWidget(
      {this.workoutName,
      this.workoutLocation,
      this.workoutDateTime,
      this.workoutId});

  final String workoutName;
  final String workoutLocation;
  final Timestamp workoutDateTime;
  final String workoutId;

  @override
  _CustomWorkoutWidgetState createState() => _CustomWorkoutWidgetState();
}

class _CustomWorkoutWidgetState extends State<CustomWorkoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.fire),
        trailing: FlatButton(
          child: FaIcon(FontAwesomeIcons.times),
          minWidth: 10.0,
          onPressed: () async {
            String deleteID;
            await _firestore.collection('workouts').get().then((snapshot) {
              snapshot.docs.forEach((doc) {
                if (doc.data()['uid'] == widget.workoutId) {
                  deleteID = doc.id;
                }
              });
            });

            await _firestore.collection('workouts').doc(deleteID).delete();

            print('Deleted');
          },
        ),
        title: Text(widget.workoutName),
        subtitle: Text(
            '${widget.workoutLocation}, on ${widget.workoutDateTime.toDate().day}/${widget.workoutDateTime.toDate().month}/${widget.workoutDateTime.toDate().year} '),
      ),
    );
  }
}

List<CustomWorkoutWidget> getWorkouts(List<QueryDocumentSnapshot> workouts) {
  List<CustomWorkoutWidget> finalWorkouts = [];
  for (var workout in workouts) {
    if (workout.data()['user'] == _auth.currentUser.email) {
      var temp = CustomWorkoutWidget(
        workoutId: workout.data()['uid'],
        workoutName: workout.data()['workout'],
        workoutDateTime: workout.data()['dateTime'],
        workoutLocation: workout.data()['location'],
      );

      finalWorkouts.add(temp);
    }
  }
  return finalWorkouts;
}
