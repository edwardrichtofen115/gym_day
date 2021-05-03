import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;

class CheckinForm extends StatefulWidget {
  @override
  CheckinFormState createState() {
    return CheckinFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CheckinFormState extends State<CheckinForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final workoutTextController = TextEditingController();
  final locationTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    String workout;
    String location;
    DateTime dateTime = DateTime.now();
    final _auth = FirebaseAuth.instance;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextFormField(
              // The validator receives the text that the user has entered.
              controller: workoutTextController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                prefixIcon: Icon(Icons.directions_run),

                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 32.0),
                    borderRadius: BorderRadius.circular(25.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 32.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Enter the workout ',
                // labelText: 'Enter your workout',
              ),
              onChanged: (value) {
                workout = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextFormField(
              // The validator receives the text that the user has entered.
              controller: locationTextController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                prefixIcon: Icon(Icons.add_location),

                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 32.0),
                    borderRadius: BorderRadius.circular(25.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 32.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Enter location',
                // labelText: 'Enter your workout',
              ),
              onChanged: (value) {
                location = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: DateTimePicker(
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
              onSaved: (value) {
                dateTime = DateTime.parse(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                _firestore.collection('workouts').add({
                  'user': _auth.currentUser.email,
                  'workout': workout,
                  'location': location,
                  'dateTime': dateTime,
                });
                workoutTextController.clear();
                locationTextController.clear();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text('Success'),
                      content: new Text('Workout saved successfully.'),
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
                FocusScope.of(context).unfocus();
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
