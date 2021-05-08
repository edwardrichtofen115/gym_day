import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_day/checkin_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;
import 'package:cool_alert/cool_alert.dart';

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
  String user_email;
  final _auth = FirebaseAuth.instance;

  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Container(
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
                  fontSize: 20.0,
                  color: Colors.black54,
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Workout',
                ),
                textAlign: TextAlign.center,
                onChanged: (newText) {
                  workout = newText;
                },
              ),
              TextFormField(
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'This field cannot be empty';
                  }
                  return null;
                },
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
                child: Platform.isIOS
                    ? CupertinoDatePicker(onDateTimeChanged: (value) {
                        // print(value);
                        dateTime = value;
                      })
                    : DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        initialValue: dateTime.toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: 'Date of workout',
                        timeLabelText: 'Time of workout',
                        onChanged: (value) {
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
                    final formState = _formKey.currentState;
                    if(formState.validate()){
                      _firestore.collection('workouts').add({
                        'user': user_email,
                        'workout': workout,
                        'location': location,
                        'dateTime': dateTime,
                        'uid': uuid.v4(),
                      });
                      Navigator.pop(context);
                      CoolAlert.show(
                          title: 'Success!!',
                          context: context,
                          type: CoolAlertType.success,
                          text: 'Workout added successfully',
                          confirmBtnColor: Colors.orange,
                          backgroundColor: Colors.orange,
                          confirmBtnText: 'Done');
                    }

                  })
            ],
          ),
        ),
      ),
    );
  }

  getUser() async {
    await SharedPreferences.getInstance().then((prefs) {
      bool status = prefs.getBool('isLoggedIn') ?? false;
      if (status) {
        user_email = prefs.getString('user_email').toString();
      } else {
        user_email = _auth.currentUser.email;
      }
      // print(user_email);
    });
  }
}
