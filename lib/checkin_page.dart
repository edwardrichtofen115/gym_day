import 'package:flutter/material.dart';
import 'package:gym_day/checkin_form.dart';

class CheckInPage extends StatefulWidget {
  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CheckinForm(),
    );
  }
}
