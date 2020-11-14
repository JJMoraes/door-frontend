import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:door/service/UserService.dart';
import 'package:door/Login.dart';
import 'package:door/Home.dart';


class Welcome extends StatefulWidget {
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  Widget build(BuildContext context) {

    double _animation = 1.0;
    UserService user = new UserService();

    return new MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: new Scaffold(
        body:new Container(
          alignment: AlignmentDirectional.center,
          margin: new EdgeInsets.all(15.0),
          child: new Center(
            child: AnimatedOpacity(
              onEnd: () async {
                if (await user.hasToken()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home())
                  );
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginForm())
                  );
                }
              },
              duration: Duration(seconds: 3),
              opacity: _animation,
              child: Text("Welcome !!")
            ),
          ),
        ),
      ),
    );
  }
}
