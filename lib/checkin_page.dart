import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_day/checkin_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;



final _firestore = FirebaseFirestore.instance;
final uuid = Uuid();
class CheckInPage extends StatefulWidget {
  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  String workout;
  String location;
  DateTime dateTime = DateTime.now();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Workout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.orangeAccent,
              ),
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Workout',
              ),
              textAlign: TextAlign.center,
              onChanged: (newText) {
                workout = newText;
              },
            ),
            TextField(
              autofocus: true,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                labelText: 'Enter the location',
              ),
              textAlign: TextAlign.center,
              onChanged: (newText) {
                location = newText;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
                child: Text(
              'Date and Time of workout',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
            )),
            SizedBox(
              height: 130.0,
              child: Platform.isIOS ? CupertinoDatePicker(onDateTimeChanged: (value) {
                print(value);
                dateTime = value;
              }) : DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: dateTime.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date of workout',
                timeLabelText: 'Time of workout',
                onChanged: (value){
                  dateTime = DateTime.parse(value);
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(

                child: Text('Add Workout'),
                onPressed: () {
                  print(workout);
                  print(location);
                  print(dateTime);
                  _firestore.collection('workouts').add({
                    'user': _auth.currentUser.email,
                    'workout': workout,
                    'location': location,
                    'dateTime': dateTime,
                    'uid' : uuid.v4(),



                  });
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

