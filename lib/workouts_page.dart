import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_day/checkin_form.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class WorkoutsPage extends StatefulWidget {

  @override
  _WorkoutsPageState createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage>{
  String user_email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }



  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream:
              _firestore.collection('workouts').orderBy('dateTime', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final workouts = snapshot.data.docs;

              List<CustomWorkoutWidget> finalWorkouts = getWorkouts(workouts, user_email);
              return ListView(
                children: finalWorkouts,
              );
            } else
              return Text('Error');
          },
        ),
      ),
    );
  }

  getUser() async{

    await SharedPreferences.getInstance().then((prefs){

      bool status = prefs.getBool('isLoggedIn') ?? false;
      if(status){
        user_email = prefs.getString('user_email').toString();
      }else{
        user_email = _auth.currentUser.email;
      }
      // print(user_email);

    });



  }
}

class CustomWorkoutWidget extends StatefulWidget {
  CustomWorkoutWidget(
      {this.workoutName,
      this.workoutLocation,
      this.workoutDateTime,
      this.workoutId,
      });

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
    final progress = ProgressHUD.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.fire),
        trailing: FlatButton(
          child: Icon(Icons.delete_forever_outlined, color: Colors.black54,),
          minWidth: 10.0,
          onPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text('Alert'),
                    content: new Text(
                        'Are you sure you want to delete this workout?'),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new TextButton(
                        child: new Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      new TextButton(
                        child: new Text("Delete"),
                        onPressed: () async {
                          String deleteID;
                          Navigator.pop(context);
                          progress.showWithText('Deleting the workout');
                          await _firestore
                              .collection('workouts')
                              .get()
                              .then((snapshot) {
                            snapshot.docs.forEach((doc) {
                              if (doc.data()['uid'] == widget.workoutId) {
                                deleteID = doc.id;
                              }
                            });
                          });

                          await _firestore.collection('workouts').doc(deleteID).delete();
                          // await Future.delayed(Duration(seconds: 10));


                          progress.dismiss();




                          // print('Deleted');
                        },
                      ),
                    ],
                  );
                });
          },
        ),
        title: Text(widget.workoutName),
        subtitle: Text(
            '${widget.workoutLocation}, on ${widget.workoutDateTime.toDate().day}/${widget.workoutDateTime.toDate().month}/${widget.workoutDateTime.toDate().year} '),
      ),
    );
  }
}

List<CustomWorkoutWidget> getWorkouts (List<QueryDocumentSnapshot> workouts, String currentUserEmail){
  List<CustomWorkoutWidget> finalWorkouts = [];

  // print(currentUserEmail.toString());
  // print(workouts[0].data()['user']);
  // print(currentUserEmail == workouts[0].data()['user']);
  for (var workout in workouts) {
    if (workout.data()['user'] == currentUserEmail) {
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
