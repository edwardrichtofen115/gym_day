import 'package:flutter/material.dart';


class HeaderContainer extends StatelessWidget {
  var text = "Login";

  HeaderContainer(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //     colors: [Colors.orange, Colors.deepOrange],
          //     end: Alignment.bottomCenter,
          //     begin: Alignment.topCenter),
        color: Colors.orange, //temporary
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                text,
                style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w700),
              )),
          Center(
            child: Image.asset("assets/images/logo3.png", height: 150.0, width: 150.0,color: Colors.white,),
          ),
        ],
      ),
    );
  }
}