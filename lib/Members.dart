import 'package:door/utils/Dialogs.dart';
import 'package:door/utils/Exceptions.dart';
import 'package:door/utils/SideMenu.dart';
import 'package:door/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:door/dto/UserDTO.dart';
import 'package:door/UserProfile.dart';

class Members extends StatefulWidget{

  @override
  MembersState createState(){
    return MembersState();
  }
}

class MembersState extends State<Members>{
  UserService userService = new UserService();
  Stream<List<UserDTO>> members;
  Future<Widget> drawer;

  @override
  void initState() {
    super.initState();
    members = this._loadMembers();
    drawer = SideMenu.build(context);
  }

  Stream<List<UserDTO>> _loadMembers() async*{
    await Future<void>.delayed(Duration(seconds: 2));
    yield await UserService().getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Members"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.perm_contact_calendar,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: new Container(
            margin: new EdgeInsets.all(5.0),
            child: StreamBuilder<List<UserDTO>>(
              stream: this.members,
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
                return new Center(child: CircularProgressIndicator());
              default:
                if(snapshot.hasError){
                  return Text("Error: ${snapshot.error}");
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
    Dialogs dialogs = new Dialogs(context, "Members:");
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
                  leading: Icon(Icons.perm_contact_calendar),
                  title: Text(snapshot.data[index].username),
                  trailing: IconButton(icon: Icon(Icons.remove_red_eye),padding: EdgeInsets.only(left: 20.0),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> UserProfile(user: snapshot.data[index]))
                      );
                    },
                  ),
                ),
                new ListTile(
                  leading: snapshot.data[index].isActive?Icon(Icons.check):Icon(Icons.cancel),
                  title: snapshot.data[index].isActive?Text("Active"):Text("Inactive"),
                ),
                new Row(
                  children: <Widget>[
                    new FlatButton(onPressed: () async{
                        if(await dialogs.showAlertDialog("Are you sure about that action ?")){
                          dialogs.showResponseDialog(userService.updateStatus(snapshot.data[index], snapshot.data[index].isActive));
                          setState(() {
                            this.members = this._loadMembers();
                          });
                        }
                      }, child: snapshot.data[index].isActive?Text("Deactivate"):Text("Activate")),
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