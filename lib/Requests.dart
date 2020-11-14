import 'package:door/utils/Dialogs.dart';
import 'package:door/utils/Exceptions.dart';
import 'package:door/utils/SideMenu.dart';
import 'package:door/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:door/dto/UserDTO.dart';
import 'package:door/UserProfile.dart';

class Requests extends StatefulWidget{

  @override
  RequestsState createState(){
    return RequestsState();
  }
}

class RequestsState extends State<Requests>{
  UserService userService = new UserService();
  Stream<List<UserDTO>> requests;
  Future<Widget> drawer;

  @override
  void initState() {
    super.initState();
    requests = this._loadRequests();
    drawer = SideMenu.build(context);
  }

  Stream<List<UserDTO>> _loadRequests() async*{
    await Future<void>.delayed(Duration(seconds: 2));
    yield await UserService().getRequests();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Requests"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.person_pin_circle,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: new Container(
            margin: new EdgeInsets.all(5.0),
            child: StreamBuilder<List<UserDTO>>(
              stream: this.requests,
              builder: (BuildContext context, AsyncSnapshot<List<UserDTO>> snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:

                  case ConnectionState.waiting:
                    return new Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError)
                      return Exceptions.build(context, snapshot.error);
                    else
                      return createListView(context, snapshot);
                }
              },
            )
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
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot<List<UserDTO>> snapshot) {
    Dialogs dialogs = new Dialogs(context, "Requests");
    return new ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            borderOnForeground: true,
            elevation: double.infinity,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  leading: Icon(Icons.person),
                  title: Text(snapshot.data[index].username),
                  trailing: IconButton(icon: Icon(Icons.remove_red_eye),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> UserProfile(user: snapshot.data[index]))
                      );
                    },
                  ),
                ),
                new ListTile(
                  leading: Icon(Icons.code),
                  title: Text(snapshot.data[index].rfid),
                ),
                new Row(
                  children: <Widget>[
                    new FlatButton(onPressed: () async{
                        if(await dialogs.showAlertDialog("Are you sure about that action ?")){
                          dialogs.showResponseDialog(userService.approve(snapshot.data[index]));
                          setState(() {
                            this.requests = this._loadRequests();
                          });
                        }
                      }, child: Text("Approve")),
                    new FlatButton(onPressed: () async{
                        if(await dialogs.showAlertDialog("Are you sure about that action ?")){
                          dialogs.showResponseDialog(userService.delete(snapshot.data[index]));
                          setState(() {
                            this.requests = this._loadRequests();
                          });
                        }
                      }, child: Text("Delete"))
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ],
            ),
          );
        }
    );
  }
}