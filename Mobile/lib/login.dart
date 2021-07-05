import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 150.0,
              child: Image.asset('assets/5.png'),
            )
          ],
        ),
      ),
    );
  }
}
