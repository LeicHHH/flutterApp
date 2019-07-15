import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/match.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sportive prototype',
      theme: ThemeData.light(),
      routes: {
        "home-page": (context) => Home(),
        "login-page": (context) => LoginPage(),
        "on-going-match": (context) => OnGoingMatch(),
      },
      home: LoginPage(),
    );
  }
}
