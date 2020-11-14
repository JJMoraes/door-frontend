import 'dart:ui';

import 'package:door/Home.dart';
import 'package:door/service/UserService.dart';
import 'package:flutter/material.dart';


class Exceptions{

  static Widget build(BuildContext context, Object error) {
    return new Container(
      alignment: AlignmentDirectional.center,
      margin: new EdgeInsets.all(5.0),
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(error.toString()),
            new RaisedButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder)=>Home())
                );
              }, child: Text("Retry"),),
          ],
        )
      ),
    );
  }
}