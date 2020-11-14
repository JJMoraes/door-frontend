import 'package:door/utils/SideMenu.dart';
import 'package:door/dto/UserDTO.dart';
import 'package:door/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:door/UpdateUser.dart';
import 'package:door/utils/Exceptions.dart';

class Home extends StatefulWidget{

  @override
  HomeState createState(){
    return HomeState();
  }
}

class HomeState extends State<Home>{

  UserService userService = new UserService();
  Future<UserDTO> user;
  String id;
  Future<Widget> drawer;

  @override
  void initState() {
    super.initState();
    user = userService.getCurrentUser();
    drawer = SideMenu.build(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Home"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.home,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: new Container(
          margin: new EdgeInsets.all(5.0),
          child: FutureBuilder<UserDTO>(
            future: this.user,
            builder: (context, snapshot){
              switch (snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(child: CircularProgressIndicator());
                default:
                  if(snapshot.hasError){
                    return Exceptions.build(context, snapshot.error);
                  }else{
                    this.id = snapshot.data.id;
                    return new Column(
                        children: <Widget>[
                          new Card(
                            borderOnForeground: true,
                            elevation: double.infinity,
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text(snapshot.data.username),
                                ),
                                new ListTile(
                                  leading: Icon(Icons.email),
                                  title: Text(snapshot.data.email),
                                ),
                                new ListTile(
                                  leading: Icon(Icons.code),
                                  title: Text(snapshot.data.rfid),
                                ),
                                new ListTile(
                                  leading: Icon(Icons.perm_contact_calendar),
                                  title: Text(snapshot.data.role),
                                ),
                                new ListTile(
                                  leading: snapshot.data.isActive?Icon(Icons.check):Icon(Icons.cancel),
                                  title: snapshot.data.isActive?Text("Active"):Text("Inactive"),
                                )
                              ],
                            ),
                          ),
                        ]
                    );
                  }
              }
            },
          ),
        ),
        drawer: FutureBuilder<Widget>(
          future: this.drawer,
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Text("Loading...");
              default:
                if(snapshot.hasError){
                  return new Text('Error: ${snapshot.error}');
                }else{
                  return snapshot.data;
                }
            }
          },
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpdateUser())
            );
          }, child: Icon(Icons.create), backgroundColor: Colors.white,
        ),
      ),
    );
  }
}