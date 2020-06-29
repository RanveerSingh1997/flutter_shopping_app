import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Text('Loading...',style:TextStyle(fontSize:24.0,fontWeight:FontWeight.w600,height:5.0),),
      ),
    );
  }
}
