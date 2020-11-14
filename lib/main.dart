import 'dart:io';

import 'package:door/Login.dart';
import 'package:door/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:door/Home.dart';

void main()=>runApp(Door());

class Door extends StatefulWidget{

  @override
  DoorState createState() => DoorState();

}

class DoorState extends State<Door> {
  UserService userService = new UserService();
  Future<bool> hasToken;

  @override
  void initState(){
    super.initState();
    this.hasToken = userService.hasToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.hasToken,
      builder: (builder, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          default:
            if(snapshot.hasError || !snapshot.hasData){
              return MaterialApp(
                home: LoginForm(),
              );
            }else{
              return snapshot.data?MaterialApp(home:Home()):MaterialApp(home:LoginForm());
            }
        }
      },
    );
  }

}