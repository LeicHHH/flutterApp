import 'package:flutter/material.dart';
import 'package:sportive_app/model/api.dart';
import 'dart:async';
import 'dart:ui' show ImageFilter;
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';


class LoginPage extends StatelessWidget {
  Future<bool> _loginUser() async {
    final api = await FBApi.signInWithGoogle();
    if (api != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(
                  width: 250.0,
                  height: 250.0,
                ),
                child: Container(
                  color: Colors.cyan[100].withOpacity(0.7),
                ),
              ),
            ),
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  width: 300.0,
                  height: 400.0,
                  color: Colors.grey[100].withOpacity(0.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Sportive",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GoogleSignInButton(
                        onPressed: () async {
                          bool b = await _loginUser();

                          b
                              ? Navigator.of(context).pushNamed('home-page')
                              : Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Fail to sign in'),
                                    ),
                                  );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
