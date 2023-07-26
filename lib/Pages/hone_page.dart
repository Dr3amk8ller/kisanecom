import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  var days = 30;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubuddy"),
      ),
      body: Center(
        child: Container(
          child: Text("Welcome to $days of flutter"),
        ),
      ),
      drawer: Drawer(),
    );
  }
}
